# Performance Checklist

A quick checklist to run alongside the [[perf-budget]] skill. Always **measure before and after** —
nothing here is worth doing on a path that isn't actually hot.

## Before You Optimize

- [ ] There's a defined target (e.g. p95 latency, bundle size, memory ceiling).
- [ ] You profiled/traced the real workload and found the dominant cost.
- [ ] The thing you're about to change is on the hot path, not a one-time setup.

## Data & I/O

- [ ] No N+1 queries — batch or join instead of looping queries.
- [ ] Independent I/O runs in parallel, not in sequence.
- [ ] Queries hit indexes; no accidental full scans on large tables.
- [ ] Pagination/limits on anything that can grow unbounded.
- [ ] Expensive, slow-changing work is cached — with a clear invalidation story.

## Compute

- [ ] No accidental O(n²) loops over large collections.
- [ ] Repeated lookups use a Map/Set, not array scans.
- [ ] Heavy work isn't repeated when it could be computed once.
- [ ] Constant constructions (regexes, configs) hoisted out of loops.

## Frontend (see [[react-patterns]])

Run the [react patterns checklist](./react-patterns-checklist.md) for the full pass. At minimum:

- [ ] No request waterfalls; cheap checks precede awaits.
- [ ] Server/Client boundary at the leaves; no server secrets in client bundles.
- [ ] Bundle impact checked; heavy/rare code lazy-loaded; barrel imports avoided.
- [ ] Unnecessary re-renders minimized; expensive renders deferred to keep input responsive.
- [ ] No layout shift; feedback within a frame or two of interaction.

## After

- [ ] Before/after numbers confirm the change helped.
- [ ] Trade-offs (cache invalidation, added complexity) are justified by the measured gain.
- [ ] A benchmark or budget guard prevents silent regression.
