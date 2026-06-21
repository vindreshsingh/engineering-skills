---
name: observability
description: Makes a system answer questions about its own behavior in production via logs, metrics, and traces. Use when building or changing a production service, adding alerts, diagnosing blind outages, or instrumenting a feature before launch.
---

# Observability

You can't operate what you can't see. Observability is the ability to ask **new questions** about a
running system without shipping code — through **logs**, **metrics**, and **traces**. Monitoring tells
you when something broke; observability helps you **why** it broke and **who** it hurt.

Build telemetry **with the feature**, not after the first outage. Adding `print` and redeploying during
[[incident-response]] is the most expensive logging strategy.

Pairs with [[launch-readiness]] for pre-launch signals, [[incident-response]] and [[fault-recovery]]
for diagnosis, [[hardening]] for safe logs (no secrets/PII), [[perf-budget]] for latency targets,
[[resilience]] for failure-path visibility, and [[llm-feature-engineering]] for AI cost/quality metrics.

## When to Use

- Building or changing a service, job, worker, or endpoint that runs in production
- Adding a feature you must judge after release ([[launch-readiness]])
- An incident took too long because signals were missing or noisy
- Setting up dashboards, alerts, SLOs, or on-call runbooks
- Post-incident action item: "we couldn't see X"
- Reviewing a PR that touches production paths without telemetry

Skip for throwaway local scripts with no production path. Still log meaningfully in CI jobs that
gate releases ([[pipeline-ops]]).

## Process

Work in order. Define health before picking tools.

### 1. Define what "healthy" means — SLIs and symptoms

Before instrumenting, answer: **what user-visible failure would we notice?**

| Signal type | Examples |
|-------------|----------|
| **Latency** | p95/p99 request duration, queue wait time |
| **Errors** | HTTP 5xx rate, failed jobs, validation failures |
| **Traffic** | Requests/sec, orders/min — context for anomalies |
| **Saturation** | CPU, memory, connection pool, queue depth, DB threads |

Pick **2–5 SLIs** (Service Level Indicators) per component — the numbers that map to user pain.

```text
Checkout API healthy when:
- p95 POST /orders < 500ms
- 5xx rate < 0.1%
- payment callback failures < 0.05%
```

**SLO** (target) and **error budget** (how much bad per month) drive alerting — not arbitrary thresholds
([[perf-budget]] for latency work). If "healthy" is undefined, every alert is guesswork.

### 2. The three pillars — use each for what it's good at

| Pillar | Best for | Weak for |
|--------|----------|----------|
| **Metrics** | Rates, aggregates, alerting, trends | Individual request story |
| **Logs** | Specific event detail, audit, errors | High-cardinality aggregation |
| **Traces** | Latency breakdown across hops | Business KPIs |

You need **all three** on critical paths — metrics page you, logs explain, traces show where time went.

**Correlation id** (`request_id`, `trace_id`) links them — same id in logs, metrics exemplars, and traces.

### 3. Structured logs — actionable, not prose

**Structured** (JSON/key-value), not free-text paragraphs:

```json
{
  "level": "error",
  "msg": "payment_failed",
  "request_id": "req_abc",
  "order_id": "ord_123",
  "error_code": "CARD_DECLINED",
  "duration_ms": 842
}
```

**Log levels — use deliberately:**

| Level | Use |
|-------|-----|
| **error** | Needs human attention or failed user operation |
| **warn** | Suspicious but handled (retry succeeded, slow dependency) |
| **info** | Lifecycle milestones (job started, deploy marker) — sparse |
| **debug** | Diagnostic — often off in prod or sampled |

If everything is `error`, on-call ignores real fires.

**Always include** on request-scoped logs: correlation id, service name, environment, key entity ids
(order, user, tenant — not PII blobs).

**Never log** ([[hardening]]): passwords, tokens, full credit cards, session cookies, raw health data.
Scrub or hash identifiers when policy requires.

**Log for action** — each error log should answer "what broke" and "what context to investigate."

Avoid: chatty per-row logs in hot loops, duplicate stack traces on every retry.

### 4. Metrics — few meaningful ones, watch cardinality

Instrument **boundaries** that matter:

- Request count + status (counter)
- Request duration (histogram — enables p95/p99)
- In-flight requests (gauge)
- Dependency call outcomes (per downstream)
- Business counters (orders_created, cache_hits) — low volume, high signal

**Naming** — consistent prefix: `service.subsystem.metric` (`checkout.payment.duration_ms`).

**Cardinality trap** — don't label metrics with unbounded values (user id, order id, URL path with
ids). High cardinality breaks systems and costs explode. Use logs/traces for per-entity detail.

**RED method** (requests): **Rate**, **Errors**, **Duration** per endpoint.
**USE method** (resources): **Utilization**, **Saturation**, **Errors**.

Prefer one histogram per endpoint over ten derived counters nobody understands.

### 5. Distributed tracing — follow one request end-to-end

**Propagate context** across HTTP headers, message queues, and async jobs:

- Incoming request → extract or generate trace id
- Outbound calls → attach trace context
- Workers → continue trace from message metadata

Spans should name **operations** (`db.query.orders`, `stripe.create_payment`) not generic `function_call`.

Traces answer: "Which hop added 800ms?" — metrics alone show only total latency.

Sample in high-traffic services — 100% trace on errors often worth keeping.

### 6. Alert on symptoms — actionable pages only

Alert when **users are or will be hurt**, with a response you can take:

| Alert on (good) | Don't page on (noise) |
|-----------------|----------------------|
| SLO breach / error budget burn | Single blip on low traffic |
| 5xx rate above threshold sustained | CPU 80% once |
| Queue depth growing unbounded | Log line matched "error" in info |
| Payment failure rate spike | Dependency blip self-recovered |

**Symptom-based** — checkout failing — beats **cause-based** — CPU high (CPU isn't always user pain).

Every alert needs:

- **Runbook link** — first steps, dashboard, rollback ([[incident-response]])
- **Severity** — page vs ticket vs log-only
- **Owner** — team/service responsible

**Alert fatigue** kills on-call — if an alert is routinely ignored, fix threshold or delete it.

Test alerts: trigger failure in staging → confirm notification fires.

### 7. Dashboards — orient during incidents and launches

One **service dashboard** per critical component:

- Golden signals (latency, errors, traffic, saturation)
- Dependency health
- Recent deploy marker
- SLO / error budget remaining

**Launch dashboard** ([[launch-readiness]]) — feature-specific metrics for rollout week, then merge or
tune for steady state.

Dashboards without alerts are **visibility** — good for diagnosis, not for waking people.

### 8. Build in with the feature — checklist per change

When adding/changing production behavior, add telemetry in the **same PR**:

- [ ] Success and failure paths logged (structured, correlated)
- [ ] Request/job duration and error rate metrics
- [ ] Trace spans on new external calls
- [ ] Alert or explicit "no alert needed" with reason
- [ ] Dashboard panel or saved query if launch-critical

**Verify telemetry works** before merge:

- Trigger error path in staging — appears in logs/metrics/traces
- Confirm cardinality safe (no user id labels)
- Confirm no secrets in emitted fields

Missing instrumentation in the PR → same class of bug as missing tests.

### 9. Jobs, queues, and batch work

Async paths need observability too:

- **Enqueue / process / complete / fail** counters
- **Processing latency** — time in queue + handle time
- **DLQ depth** and poison message logging
- **Batch progress** — rows processed, last checkpoint, ETA logs
- Alert on **stuck** jobs (no progress N minutes) and **DLQ growth**

A silent failing cron is a production outage with no pages.

### 10. Frontend and client signals (when applicable)

Browser errors, API failures from client, and Core Web Vitals complement server telemetry:

- JS error reporting (sanitized)
- Client-side latency to API
- Feature flag variant in client logs for correlation

Server-only observability misses CDN, client bugs, and partial outages visible to users
([[browser-checks]] complements).

### 11. Cost and sampling — observability isn't free

- **Log volume** — cost and query slowness; sample debug; aggregate where possible
- **Trace sampling** — balance cost vs coverage; always sample errors
- **Metric cardinality** — audit label sets
- **Retention** — hot vs cold storage; compliance for audit logs

More telemetry isn't always better — **signal over noise** ([[context-curation]] applies to ops too).

### 12. Scenario playbooks

**New HTTP service**

RED metrics per route → structured access logs → trace propagation → SLO + alert on 5xx/latency →
runbook.

**New background consumer**

Queue depth gauge → process latency histogram → DLQ alert → idempotent failure logs with message id.

**Feature launch** ([[launch-readiness]])

Define healthy → dashboard panel → alert thresholds → trigger test in staging → watch through ramp.

**Post-incident "we were blind"**

Gap analysis → add metric/log/trace at failure point → alert on symptom → runbook update → verify in
staging.

**Slow endpoint** ([[perf-budget]])

Trace sample → find dominant span → fix → compare p95 before/after on dashboard.

**LLM feature** ([[llm-feature-engineering]])

Token usage, model latency, schema validation failure rate, fallback rate, quality proxy metrics.

**Multi-tenant SaaS**

Per-tenant metrics only if low tenant count or aggregated; never explode cardinality with per-user
metrics labels.

**On-call setup**

Service catalog → dashboards → SLOs → paging alerts → runbooks → escalation → game day fire drill.

## Common Rationalizations

- "We'll add logging when something breaks." — Worst time to discover gaps; incidents get longer.
- "More logs are safer." — Noise buries signal; costs money; PII risk grows.
- "A dashboard covers it." — Dashboards don't page; alerts on symptoms do.
- "We'll know if it's down." — Partial failures, latency, and wrong data aren't "down."
- "Metrics are the platform team's job." — Service owners know what failure looks like.
- "Alert on everything." — Fatigue → ignored real outages.
- "Trace everything 100%." — Cost and overhead; sample intelligently.
- "Error logs are enough." — Without rates and latency, you don't know severity or trend.

## Red Flags

- Diagnosing prod by adding prints and redeploying
- Unstructured logs — can't filter `order_id=`
- Secrets, tokens, or PII in logs/traces
- Alerts fire constantly and are ignored
- No correlation id across services
- "Healthy" undefined — no SLO, random thresholds
- High-cardinality metric labels (user_id, url with ids)
- New production path with zero metrics in PR
- Batch job with no failure or stall alert
- Dashboards exist but on-call doesn't know which to open
- Traces don't cross service boundaries
- Error budget concept missing — alert thresholds arbitrary
- Telemetry never tested — alert doesn't actually notify

## Verification

- [ ] SLIs defined — latency, errors, traffic, saturation map to user pain
- [ ] Structured logs with levels, correlation id, entity ids; no secrets/PII ([[hardening]])
- [ ] RED/USE metrics on critical boundaries; cardinality controlled
- [ ] Traces propagate across sync and async hops
- [ ] Alerts on actionable symptoms with runbooks; tested in staging
- [ ] Dashboard exists for service + launch-critical features ([[launch-readiness]])
- [ ] Async jobs: depth, latency, DLQ, stall alerts
- [ ] Telemetry added in same PR as production behavior change
- [ ] Error/failure path verified in logs, metrics, and traces
- [ ] Sampling and retention appropriate for cost and compliance
