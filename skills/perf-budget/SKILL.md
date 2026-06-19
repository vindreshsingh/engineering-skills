---
name: perf-budget
description: Optimizes performance by measuring first and fixing the real bottleneck. Use when something is slow, before optimizing, or when setting performance targets — not for speculative micro-tuning.
---

# Perf Budget

Performance work starts with a number and a measurement, not a hunch. Set a target, measure to find
the real bottleneck, fix that, and measure again. Optimizing the wrong thing is wasted effort that
adds complexity for no gain.

## When to Use

- A page, query, job, or endpoint is measurably slow
- Setting or enforcing performance targets (latency, bundle size, memory)
- Before optimizing anything — to confirm where the time actually goes
- Reviewing for obvious performance traps (see [[review-gate]])

## Process

1. **Define the target.** What metric, measured how, against what budget? "Faster" isn't a goal;
   "p95 under 200ms" is.
2. **Measure first.** Profile or trace the real workload. The bottleneck is usually not where you'd
   guess — intuition about hotspots is famously wrong.
3. **Fix the biggest bottleneck**, the one dominating the cost. Don't shave microseconds off code
   that runs once.
4. **Prefer algorithmic and structural wins** — remove N+1 queries, batch/parallelize independent
   I/O, cache expensive repeat work, fix accidental O(n²) — before micro-optimizations.
5. **Measure again** to confirm the fix moved the number. If it didn't, revert it.
6. **Watch the trade-offs.** Caching adds invalidation; parallelism adds complexity. Spend complexity
   only where it buys real, measured speed.
7. **Add a guard** (benchmark, budget check) so the regression can't silently creep back.

## Common Rationalizations

- "This code is obviously the slow part." — Profile it; the obvious culprit is usually innocent.
- "Micro-optimizing can't hurt." — It adds complexity and risk for gains that may not exist.
- "We don't have time to measure." — You have less time to optimize the wrong thing twice.
- "Add a cache, it'll be faster." — Until stale data or invalidation bugs cost more than you saved.

## Red Flags

- Optimizing before profiling
- Tuning a path that runs rarely while ignoring the hot one
- No before/after numbers to justify a change
- Caching added without an invalidation story
- Cleverness that hurts readability for an unmeasured, possibly nonexistent gain

## Verification

- [ ] A concrete target/budget was defined
- [ ] The bottleneck was found by measuring, not guessing
- [ ] The dominant cost was addressed first (structure/algorithm before micro-tuning)
- [ ] Before/after numbers confirm the improvement
- [ ] Trade-offs (cache invalidation, complexity) are accounted for
- [ ] A guard exists to catch regressions
