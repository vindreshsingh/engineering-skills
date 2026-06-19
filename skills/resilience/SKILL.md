---
name: resilience
description: Makes code correct under failure — timeouts, retries, idempotency, graceful degradation. Use when calling a network/external dependency, writing a job that can be retried, or handling anything that can fail partway.
---

# Resilience

In a distributed system, dependencies will be slow, fail, or return twice. Resilient code assumes
this: it bounds how long it waits, retries safely, stays correct when called again, and degrades
instead of collapsing. The happy path is the easy part — failure handling is the engineering.

## When to Use

- Any call across a network boundary (API, DB, queue, cache, third party)
- Background jobs, webhooks, or message consumers that may be retried or redelivered
- Operations that change state and must not double-apply
- Anywhere a partial failure could leave the system inconsistent

## Process

1. **Set a timeout on every remote call.** An unbounded wait turns a slow dependency into your own
   outage. No default-infinite timeouts.
2. **Retry only what's safe, with backoff + jitter.** Retry transient failures (timeouts, 5xx, network)
   — never retry a non-idempotent write blindly, and cap attempts so you don't amplify an outage.
3. **Make state-changing operations idempotent.** Use idempotency keys, upserts, or dedup so a retry or
   redelivery applies exactly once. Assume every message can arrive twice.
4. **Fail fast and isolate.** Use circuit breakers / bulkheads so one failing dependency doesn't
   exhaust threads, connections, or cascade across the system.
5. **Degrade gracefully.** Define the fallback when a non-critical dependency is down — serve stale
   cache, a default, or a reduced experience instead of erroring the whole request.
6. **Don't swallow failures.** Surface them to observability ([[observability]]); a silent catch hides
   the very problem you need to see.
7. **Test the failure paths** — inject timeouts, errors, and duplicate deliveries, not just success.

## Common Rationalizations

- "The network is reliable." — The first fallacy of distributed computing; design for it failing.
- "It'll succeed on retry." — Not if the retry double-charges the customer; make it idempotent first.
- "A default timeout is fine." — Many client defaults are infinite or minutes long; set it explicitly.
- "Catch and log is enough." — Catch-and-continue without a fallback often corrupts state silently.

## Red Flags

- Network calls with no timeout configured
- Retries on writes that aren't idempotent
- A message consumer that assumes exactly-once delivery
- One slow dependency taking down unrelated requests (no isolation)
- `catch (e) {}` that hides failures
- Failure paths that were never tested

## Verification

- [ ] Every remote call has an explicit, bounded timeout
- [ ] Retries use backoff+jitter, are capped, and only wrap safe/idempotent operations
- [ ] State changes are idempotent against retries and duplicate delivery
- [ ] Failing dependencies are isolated (circuit breaker/bulkhead) and degrade gracefully
- [ ] Failures are surfaced to telemetry, not swallowed
- [ ] Failure paths are covered by tests
