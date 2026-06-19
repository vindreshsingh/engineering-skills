---
name: caching-strategy
description: Adds caching that speeds reads without serving stale or wrong data. Use when a read is expensive and repeated, when adding a cache layer, or when debugging stale-data or cache-invalidation bugs.
---

# Caching Strategy

A cache trades freshness and complexity for speed. It's powerful and dangerous: the gains are real,
but invalidation bugs serve wrong data to users and are hard to reproduce. Cache deliberately — know
what you're caching, for how long, and exactly how it becomes correct again.

## When to Use

- A read is expensive (slow query, remote call, heavy computation) and happens repeatedly
- The same data is requested far more often than it changes
- Adding or tuning a cache layer (in-memory, shared/Redis, HTTP/CDN)
- Diagnosing stale data, thundering-herd, or invalidation bugs

Don't reach for a cache first — confirm there's a measured read cost ([[perf-budget]]); often a better
query or index ([[data-modeling]]) beats a cache.

## Process

1. **Confirm it's worth caching.** Cache data that is read-heavy, slow to produce, and tolerant of some
   staleness. Don't cache cheap reads or data that must always be exact.
2. **Pick the layer for the access pattern.** Per-request memoization, per-process in-memory, shared
   cache across instances, or HTTP/CDN at the edge — each has different scope and invalidation.
3. **Choose the invalidation strategy up front** — this is the hard part, decide it before coding:
   - **TTL/expiry** for data that can be briefly stale (simplest, bounded staleness).
   - **Write-through / explicit invalidation** when you control the writes and need freshness.
   - **Keyed by version/etag** so a content change changes the key.
4. **Design keys carefully.** Include every input the value depends on (tenant, user, params, version).
   A key that omits a dimension serves one user's data to another.
5. **Set a bounded size and eviction policy** (LRU/size/TTL) so the cache can't grow unbounded
   ([[resilience]]).
6. **Handle misses and stampedes.** On a cold/expired key, prevent every caller from recomputing at
   once (single-flight / lock / stale-while-revalidate).
7. **Never cache per-user/sensitive data in a shared/public cache** without scoping the key — a
   security and privacy hazard ([[hardening]]).
8. **Measure hit rate and correctness.** Instrument it ([[observability]]); a low hit rate means the
   cache is cost without benefit.

## Common Rationalizations

- "Add a cache, it'll be faster." — Until invalidation is wrong and users see stale or other people's data.
- "TTL of an hour is fine." — Only if an hour of staleness is acceptable; decide that explicitly.
- "The key is just the id." — Missing a dimension (tenant, locale, version) leaks or corrupts data.
- "Cache everything." — Caching cheap or rarely-reused data adds complexity for no real gain.

## Red Flags

- A cache added before any read cost was measured
- No defined invalidation strategy ("we'll figure out staleness later")
- Cache keys missing an input the value depends on
- Unbounded cache with no eviction
- Per-user data in a shared/CDN cache without per-user keying
- Every expired key triggering a stampede of recomputation
- No visibility into hit rate or staleness

## Verification

- [ ] The cached data is genuinely read-heavy, expensive, and staleness-tolerant
- [ ] Cache layer matches the access pattern and scope
- [ ] Invalidation strategy is explicit and correct (TTL / write-through / versioned key)
- [ ] Keys include every dimension the value depends on
- [ ] Bounded size with an eviction policy; stampedes are prevented
- [ ] No sensitive/per-user data in a shared cache without scoped keys
- [ ] Hit rate and correctness are measured
