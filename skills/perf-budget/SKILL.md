---
name: perf-budget
description: Optimizes performance by measuring first and fixing the real bottleneck. Use when something is slow, before optimizing, when setting latency or bundle targets, or reviewing changes for performance traps — not for speculative micro-tuning.
---

# Perf Budget

Performance work starts with a **number** and a **measurement**, not a hunch. Set a budget, profile the
real workload, fix the **dominant** cost, measure again, and add a guard so regression can't sneak back.
Optimizing the wrong layer — micro-tuning a cold path while N+1 queries dominate — wastes effort and
adds complexity.

A **perf budget** is an explicit target: p95 latency, bundle kilobytes, query time, memory ceiling.
Without one, "faster" is unmeasurable and every optimization is premature.

Run the [performance checklist](../../references/performance-checklist.md) alongside this process for
common traps — only after you've confirmed the path is hot. Pair with [[observability]] for production
numbers, [[data-modeling]] for query/index work, [[caching-strategy]] only after read cost is measured,
[[react-patterns]] for React/Next.js specifics, and [[browser-checks]] for perceived slowness in the UI.

## When to Use

- A page, API, query, job, or interaction is **measurably** slow
- Setting or enforcing targets — SLOs, bundle budgets, CI perf gates
- **Before** optimizing — confirm where time actually goes
- Reviewing PRs for obvious traps ([[review-gate]]) — N+1, waterfalls, unbounded work
- After a launch when latency or error budget regressed ([[launch-readiness]])

**Skip** micro-optimization on cold paths, one-time setup, or code with no user-facing latency impact.
Don't demand perf work on every PR — apply when the path is hot or the budget is at risk.

**Not a substitute for** [[caching-strategy]] — measure first; cache only when read cost justifies it.

## Process

Work in order. No code changes until you have a baseline number.

### 1. Define the budget — make "fast" concrete

Write the target before profiling:

| Surface | Example budgets |
|---------|-----------------|
| **API** | p95 < 200ms, p99 < 500ms for `POST /orders` |
| **Page** | LCP < 2.5s, TTI < 3s on 4G ([[browser-checks]]) |
| **Query** | < 50ms p95 at 10M rows; examines < 1% of table |
| **Job** | Process 10k msgs/min; p95 handle < 2s |
| **Bundle** | Main chunk < 200KB gzip; route chunk < 80KB |
| **Memory** | Worker steady < 512MB under peak load |

Include:

- **Metric** — what (latency, size, throughput)
- **Statistic** — p50 vs p95 vs p99 (tail matters for UX)
- **Workload** — realistic data volume, concurrency, payload size
- **Environment** — prod-like, not empty dev DB

Align with SLOs in [[observability]] — perf budgets feed alerts and error budgets.

```text
Bad:  "Checkout should be fast"
Good: "POST /orders p95 < 500ms at 100 RPS, prod-like cart (20 items)"
```

### 2. Measure baseline — production truth beats guesswork

**Prefer production or prod-like** measurements ([[observability]]):

- APM traces — p95/p99 per endpoint, span breakdown
- DB slow query log, `EXPLAIN ANALYZE` on realistic volume ([[data-modeling]])
- Browser Performance tab, Lighthouse, Web Vitals ([[browser-checks]])
- Load test at expected concurrency — find saturation, not just single-request time

**Profile the dominant path:**

| Layer | Tools / signals |
|-------|-----------------|
| **Backend** | Trace waterfall, CPU profiler, flame graph |
| **Database** | Query plan, rows examined vs returned, lock wait |
| **Frontend** | Network waterfall, React profiler, bundle analyzer |
| **Batch** | Per-stage timing, queue lag |

Record **baseline numbers** in the ticket/PR — you'll need them for after.

**Intuition is wrong** — the slow function you remember is often 2% of request time; one unindexed
query or serial await chain is the real killer.

### 3. Find the bottleneck — one dominant cost

Ask: **what single change would move the budget most?**

Rank costs from profile/trace:

```text
POST /orders p95 840ms breakdown (example):
  payment API     520ms  ← dominant
  DB insert        45ms
  tax calculation  12ms
  JSON serialize    3ms
```

Fix **payment** first — not JSON. Shaving 1ms off serialize when payment is 520ms is waste.

**Hot path check** — does this code run per request at scale? One-off admin export ≠ checkout API.

If multiple similar costs, fix the **easiest high-impact** first — sometimes parallelizing two 200ms
calls beats optimizing one 50ms call.

### 4. Fix structural wins before micro-optimizations

**Priority order** (stop when budget met):

| Priority | Win | Skills |
|----------|-----|--------|
| 1 | Remove N+1; batch/join queries | [[data-modeling]] |
| 2 | Add/fix indexes for real query patterns | [[data-modeling]] |
| 3 | Parallelize independent I/O; kill waterfalls | [[react-patterns]] |
| 4 | Paginate/limit unbounded work | [[data-modeling]] |
| 5 | Algorithm fix — O(n²) → O(n), better structure | [[simplify]] |
| 6 | Cache expensive **measured** reads | [[caching-strategy]] |
| 7 | Lazy load / split bundle | [[react-patterns]] |
| 8 | Micro-tune hot loop | Only with profiler proof |

**Caching last among structural options** — confirm read cost on hot path first ([[caching-strategy]]).
A better query often removes the need entirely.

**One change at a time** when validating — or isolate in benchmark — so you know what moved the number
([[fault-recovery]] discipline).

### 5. Measure again — prove it worked or revert

After each meaningful change:

- Re-run same workload / benchmark / trace comparison
- Compare **same statistic** (p95, not p50 only)
- Check **regressions** elsewhere — faster checkout but 2× DB load?

```text
Before: p95 840ms | After: p95 310ms | Budget: 500ms ✓
```

**If the number didn't move** — revert the change unless it bought clarity or mandatory fix.
Don't keep "optimizations" that profiler can't justify.

Document before/after in PR — reviewers and future-you need proof.

### 6. Account for trade-offs — speed isn't free

Every perf win can cost something — name it:

| Optimization | Trade-off |
|--------------|-----------|
| Cache | Staleness, invalidation bugs ([[caching-strategy]]) |
| Parallelism | Connection pool pressure, harder debugging |
| Denormalization | Write complexity, consistency ([[data-modeling]]) |
| Aggressive bundling | Cacheability, deploy granularity |
| Lower sampling | Less observability detail |

Spend complexity only where measurement shows **user-visible** gain. A 5ms win on a 2s page isn't worth
opaque code.

### 7. Add guards — prevent silent regression

Lock the win:

| Guard | When |
|-------|------|
| **Benchmark in CI** | Critical pure logic; threshold assert |
| **Bundle size budget** | Frontend CI fails if chunk grows > X KB |
| **Load test gate** | Release pipeline p95 check ([[pipeline-ops]]) |
| **SLO alert** | Production p95 regression ([[observability]]) |
| **Query plan check** | EXPLAIN in test on representative query |

Guards should match the **same metric** you optimized — not a different proxy that drifts.

Re-baseline when workload changes — budgets aren't forever.

### 8. Layer-specific playbooks

**Slow API endpoint**

Trace → rank spans → N+1 / missing index / external call → fix dominant → re-trace → SLO alert.

**Slow SQL**

`EXPLAIN ANALYZE` on prod stats → rows examined → index or rewrite → measure at volume
([[data-modeling]]).

**Slow page load**

Network waterfall → LCP element → bundle size + critical path → lazy load / server fetch parallel
([[react-patterns]], [[browser-checks]]).

**Slow React interaction**

Profiler → unnecessary re-renders vs expensive render → fix render or defer work → 60fps input check.

**Background job behind**

Queue depth + per-message timing → slow handler step → batch DB writes → throughput metric.

**"Feels slow" user report**

Reproduce with trace → compare p95 vs p50 (tail issue?) → [[browser-checks]] on real device/network.

**Pre-launch perf pass** ([[launch-readiness]])

Define budget → load test staging → fix blockers → dashboard + alert before 100% ramp.

### 9. When NOT to optimize

- Cold path (admin export once a day)
- Already within budget with headroom
- Hypothetical scale ("might have 1M users someday") without current pain
- Readability collapse for unmeasured micro-gains
- Caching before measuring read cost
- Optimizing staging with 3 rows when prod has 10M

Ship the feature; measure in prod; optimize what prod proves is slow ([[observability]]).

## Common Rationalizations

- "This code is obviously the slow part." — Profile it; obvious culprits are often innocent.
- "Micro-optimizing can't hurt." — Complexity and risk without measured gain hurts maintainability.
- "We don't have time to measure." — Less time than optimizing the wrong thing twice.
- "Add a cache, it'll be faster." — Measure first; invalidation bugs cost more than slow reads.
- "p50 looks fine." — Users hit p99 tail; tail is UX for many flows.
- "Staging was fast enough." — Data volume and concurrency differ in prod.
- "We'll add perf tests later." — Regressions ship in the meantime.
- "Parallel always helps." — Pool exhaustion and contention can slow the system.

## Red Flags

- Optimizing before profiling or tracing
- Fixing cold path while hot path still over budget
- No before/after numbers in PR
- Cache added without measured read cost or invalidation ([[caching-strategy]])
- N+1 or full table scan visible in trace — unaddressed
- Bundle grew with no budget check
- Micro-optimization with no profiler evidence
- Load test never run before high-tier launch
- p50 cited when users complain about sporadic slowness
- Perf "fix" that increases error rate or memory without acknowledgment
- CI perf guard disabled to green the build

## Verification

- [ ] Concrete budget defined — metric, statistic, workload, environment
- [ ] Baseline measured on hot path — trace/profile/query plan, not guesswork ([[observability]])
- [ ] Dominant bottleneck identified and fixed first (structural before micro)
- [ ] [Performance checklist](../../references/performance-checklist.md) applied to changed hot paths
- [ ] Before/after numbers documented; budget met or explicit acceptance of gap
- [ ] Trade-offs named — cache, parallelism, consistency, complexity
- [ ] Regression guard added or existing SLO/alert covers the metric ([[pipeline-ops]])
- [ ] Caching only if read cost measured and invalidation designed ([[caching-strategy]])
- [ ] Frontend: bundle and interaction checked if UI path ([[react-patterns]], [[browser-checks]])
