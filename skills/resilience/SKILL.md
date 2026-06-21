---
name: resilience
description: Makes code correct under failure — timeouts, retries, idempotency, isolation, and graceful degradation. Use when calling a network or external dependency, writing a job or webhook handler that can be retried, or handling anything that can fail partway.
---

# Resilience

In a distributed system, dependencies will be slow, fail, or return twice. Resilient code assumes
this: it bounds how long it waits, retries safely, stays correct when called again, isolates failing
parts, and degrades instead of collapsing. The happy path is the easy part — failure handling is the
engineering.

Resilience is not "catch everything and hope." It's explicit contracts: what can fail, what happens
when it does, and how the system stays correct. Pair with [[observability]] so failures are visible,
[[interface-design]] for idempotency keys and error contracts at boundaries, [[hardening]] for
webhook verification and untrusted retries, [[caching-strategy]] for stale-while-revalidate fallbacks,
[[fault-recovery]] when something is already broken in prod, and [[incident-response]] when failure
escalates to an outage.

## When to Use

- Any call across a network boundary — HTTP APIs, databases, caches, queues, third-party SDKs
- Background jobs, cron tasks, or workers that may be retried or run twice
- Webhooks and message consumers — assume **at-least-once** delivery
- Operations that change state and must not double-apply (payments, inventory, sends)
- Multi-step flows where a partial failure could leave data inconsistent
- Reviewing PRs that add outbound calls, async handlers, or retry logic
- Designing APIs others will retry against ([[interface-design]])

**Skip** as the primary skill for pure UI layout or internal refactors with no I/O boundary change —
still scan if the diff touches remote calls, queues, or error handling.

**Not a substitute for** [[observability]] — resilience without telemetry is flying blind; you won't
know the breaker opened or retries are amplifying an outage.

## Process

Work in order. Map dependencies before tuning individual timeouts.

### 1. Map dependencies and failure impact

List every **external dependency** the path touches and classify it:

| Dependency | Critical? | Failure mode | User impact if down |
|------------|-----------|--------------|---------------------|
| Payment API | Yes | timeout, 5xx | Can't checkout — must fail clearly |
| Product catalog | Yes | slow | Page slow — timeout + cache fallback |
| Recommendations | No | timeout | Degrade to empty/default |
| Email sender | No | 5xx | Queue for retry — don't block HTTP response |

For each dependency decide:

- **Timeout budget** — how long can this call block the caller?
- **Retry policy** — transient only? idempotent? max attempts?
- **Fallback** — fail the request, serve stale, skip feature, or queue for later?
- **Blast radius** — can this dependency exhaust threads, connections, or memory for unrelated work?

Critical paths get stricter timeouts and no silent degradation. Non-critical paths get fallbacks
so one flaky vendor doesn't take down checkout.

### 2. Set explicit, bounded timeouts on every remote call

An unbounded wait turns a slow dependency into **your own outage**. Client library defaults are often
too long or infinite — set timeouts explicitly per dependency.

- **Connect timeout** — how long to establish a connection (usually shorter).
- **Read/request timeout** — how long to wait for a response after connected.
- **Overall deadline** — propagate a budget across chained calls so inner calls don't eat the whole
  slice.

```text
Bad:  fetch(url)  // default may be minutes or none
Good: fetch(url, { signal: AbortSignal.timeout(3000) })
```

- Timeouts are **expected outcomes**, not exceptional bugs — handle them in the retry/fallback policy,
  not only in a generic catch.
- **Propagate cancellation** — when the caller gives up, cancel in-flight work (AbortSignal, context
  cancel) so you don't waste resources on a response nobody waits for.
- **DB and cache calls count** — a hung query blocks a connection from the pool ([[data-modeling]]).

### 3. Retry only what's safe — backoff, jitter, and caps

Retries fix **transient** failures. They amplify **persistent** ones.

**Retry when:**

- Timeout, connection reset, DNS blip
- HTTP 429 (respect `Retry-After`) and **idempotent** 5xx
- Known-safe read retries

**Do not retry blindly when:**

- 4xx (except 429) — client error won't fix itself
- Non-idempotent writes without dedup — **double-charge, double-send**
- The dependency is clearly down — circuit breaker should open first

**Policy:**

- **Exponential backoff** — e.g. 100ms → 200ms → 400ms
- **Jitter** — randomize delay so retries don't synchronize into a thundering herd
- **Max attempts** — cap total tries (e.g. 3–5); more attempts ≠ more reliability
- **Retry budget** — limit retry share of total traffic so a failing dependency doesn't 10× load

```text
Attempt 1 → fail → wait ~100ms + jitter
Attempt 2 → fail → wait ~200ms + jitter
Attempt 3 → fail → stop; surface error or fallback
```

Log each retry with **dependency, attempt, reason, latency** ([[observability]]) — silent retries
hide systemic problems until they become incidents.

### 4. Make state-changing operations idempotent

Assume every write can run **twice** — client retry, queue redelivery, worker crash after commit,
load balancer replay. Design so the second call has the same effect as the first.

| Pattern | When |
|---------|------|
| **Idempotency key** | Client-generated key on POST/create; store result keyed by it | 
| **Natural idempotency** | PUT with full state, DELETE by ID |
| **Upsert / ON CONFLICT** | DB insert that safely no-ops or updates on duplicate |
| **Dedup table** | Record processed message/event IDs before side effects |
| **Outbox + single consumer** | Exactly-once *effect* via transactional outbox |

```text
POST /payments
Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000

→ First call: charge + store result under key
→ Retry with same key: return stored result, no second charge
```

- Idempotency keys need a **TTL or scope** — don't grow the dedup store forever.
- **Check-then-act is not idempotent** — two concurrent requests both pass the check. Use unique
  constraints, compare-and-swap, or serializable transactions ([[data-modeling]]).
- Document idempotency guarantees on **public APIs** ([[interface-design]]).

### 5. Isolate failing dependencies — circuit breakers and bulkheads

One sick dependency shouldn't exhaust resources for everything else.

**Circuit breaker** — stop calling a dependency that's clearly failing:

```text
Closed   → normal calls
Open     → fail fast (or fallback) without calling dependency
Half-open → probe with limited traffic; close if healthy
```

- Open on error rate or consecutive failures — not a single timeout.
- Half-open probes prevent permanent "never try again."
- Expose breaker state in metrics ([[observability]]).

**Bulkhead** — partition resources so one pool can't drain another:

- Separate connection pools per dependency or tenant tier
- Limit concurrent calls to a flaky API (semaphore / rate limit)
- Dedicated worker queues for heavy vs light jobs

**Fail fast** when the breaker is open — don't queue unbounded work behind a dead dependency.

### 6. Degrade gracefully — define the fallback before you need it

When a **non-critical** dependency fails, decide in advance what the user gets:

| Fallback | Trade-off |
|----------|-----------|
| **Stale cache** | Fast but possibly outdated ([[caching-strategy]]) |
| **Default/empty** | Feature absent but page loads |
| **Reduced response** | Core fields only, extras omitted |
| **Async queue** | Acknowledge now, complete later (email, analytics) |
| **Hard fail** | Required for critical path — clear error, no silent wrong data |

Rules:

- **Never return wrong data silently** — stale is OK if labeled or acceptable; fabricated is not.
- **User-visible degradation** beats a 500 when the core journey still works — but tell the user
  ("Recommendations unavailable") or log for support.
- **Feature flags** can flip non-critical paths off without a deploy ([[launch-readiness]]).
- Fallback code paths need **tests too** — they're often untested until prod.

### 7. Handle queues, webhooks, and async work correctly

Message systems deliver **at-least-once**. Your handler must be idempotent (step 4).

- **Ack only after side effects are durable** — ack-before-write loses messages on crash; write-before-ack
  with idempotency is the safe pattern.
- **Visibility timeout / lease** — if processing takes longer than the lease, another consumer may
  duplicate; design for it.
- **Dead-letter queue (DLQ)** — poison messages that always fail shouldn't infinite-retry; move to DLQ
  with alert after N attempts.
- **Webhooks** — verify signature + timestamp ([[hardening]]), respond quickly (202 + async process if
  heavy), handle duplicate delivery via dedup key.
- **Ordering** — if order matters, partition by key (same key → same consumer) or detect gaps; don't
  assume global order from a queue.

```text
Bad:  receive message → charge card → ack
      (crash after charge, before ack → redelivery → double charge)

Good: receive → idempotency check → charge → record processed ID → ack
```

### 8. Handle partial failure in multi-step flows

When step 3 of 5 fails, steps 1–2 may already have committed.

Options (pick explicitly — don't leave ambiguous state):

- **Saga / compensation** — run undo steps (cancel reservation, refund hold); compensations must
  also be idempotent.
- **Single transaction** — all-or-nothing when one DB can cover it.
- **Outbox + eventual consistency** — commit intent, async workers complete or retry.
- **Pending state** — mark record `processing`; background job finishes or marks `failed` with
  user-visible recovery.

Avoid **orphan records** — created child without parent, charged without order — document the
cleanup path or use state machines with valid transitions only.

### 9. Surface failures — never swallow silently

Resilience without visibility is luck.

- **Log with context** — dependency, operation, latency, attempt, error class, correlation/trace ID
  ([[observability]]). Not full PII or secrets ([[hardening]]).
- **Metrics** — error rate, timeout rate, retry count, breaker state, DLQ depth, fallback serve rate.
- **Return structured errors to callers** — distinguish timeout vs unavailable vs validation ([[interface-design]]).
- **`catch (e) {}` is almost always wrong** — at minimum log + increment metric + fail or fallback
  explicitly.

When diagnosing live issues, switch to [[fault-recovery]]; when impact is broad, [[incident-response]].

### 10. Test failure paths — not just the happy path

If you didn't test it failing, it fails in prod untested.

- **Unit/integration:** mock timeout, 500, connection refused, duplicate delivery
- **Contract tests:** verify retry headers, idempotency key behavior ([[interface-design]])
- **Chaos or fault injection:** kill dependency in staging, verify breaker opens and fallback serves
- **Load + failure:** retries under load don't amplify outage (retry budget holds)

Test matrix minimum:

| Scenario | Expected |
|----------|----------|
| Dependency timeout | Retry if safe → fallback or clear error |
| Dependency 500 | Same |
| Duplicate message delivery | Single side effect |
| Breaker open | Fail fast, no call storm |
| Partial multi-step failure | Consistent state or compensation |

## Common Rationalizations

- "The network is reliable." — The first fallacy of distributed computing; design for it failing.
- "It'll succeed on retry." — Not if the retry double-charges the customer; make it idempotent first.
- "A default timeout is fine." — Many client defaults are infinite or minutes long; set it explicitly.
- "Catch and log is enough." — Catch-and-continue without a fallback often corrupts state silently.
- "We'll add a circuit breaker later." — Without isolation, the first sustained outage takes everything
  with it.
- "The queue guarantees exactly-once." — Practically no; assume at-least-once and dedup.
- "Retries are free." — Retries multiply load on a sick dependency; cap them and use backoff+jitter.
- "Degrading is embarrassing." — A 500 on the whole page is worse than a missing sidebar with a clear
  message.

## Red Flags

- Network calls with no timeout configured
- Retries on writes that aren't idempotent
- A message consumer that assumes exactly-once delivery
- Ack-before-write on messages with side effects
- One slow dependency taking down unrelated requests (no isolation)
- `catch (e) {}` or catch-and-log with no metric, fallback, or rethrow
- Failure paths and fallback branches never tested
- Idempotency keys stored without TTL — unbounded growth
- Retry loop with no max attempts or jitter
- Fallback serves fabricated data with no staleness indicator
- DLQ missing — poison messages retry forever

## Verification

- [ ] Dependencies mapped with timeout, retry, fallback, and blast-radius decisions
- [ ] Every remote call has explicit connect + read/deadline timeouts; cancellation propagated
- [ ] Retries use exponential backoff + jitter, capped attempts, and only wrap safe/idempotent ops
- [ ] State-changing operations idempotent against retries and duplicate delivery
- [ ] Failing dependencies isolated (circuit breaker/bulkhead); open breaker fails fast
- [ ] Non-critical paths have defined fallbacks; critical paths fail clearly — no silent wrong data
- [ ] Queue/webhook handlers: verify, dedup, durable write before ack, DLQ for poison messages
- [ ] Multi-step flows have explicit partial-failure strategy (compensation, pending state, or transaction)
- [ ] Failures logged and metered with correlation IDs — not swallowed ([[observability]])
- [ ] Failure paths tested: timeout, 5xx, duplicate delivery, breaker open

## Further Reading

- Release It! (Nygard) — stability patterns (circuit breaker, bulkhead, timeout)
- Google SRE — handling overload, retries, and cascading failures
- AWS Architecture Blog — exponential backoff and jitter
- Idempotency keys — Stripe and similar API docs for practical patterns

> Patterns reflect widely-documented distributed-systems guidance. Written for this repo; not a
> reproduction of any third-party document.
