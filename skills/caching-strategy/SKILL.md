---
name: caching-strategy
description: Adds caching that speeds reads without serving stale or wrong data. Use when a read is expensive and repeated, when adding or tuning a cache layer, or when debugging stale-data and invalidation bugs.
---

# Caching Strategy

A cache trades freshness and complexity for speed. Gains are real; invalidation bugs serve wrong data
to users and are hard to reproduce. Cache deliberately — know what you're caching, for how long, and
exactly how it becomes correct again.

The [caching patterns reference](../../references/caching-patterns.md) has layer selection, invalidation
models, key design, HTTP headers, stampede prevention, security, and the full checklist. Use this
skill for decisions; use the reference while implementing.

## When to Use

- A read is expensive (slow query, remote call, heavy computation) and happens repeatedly
- The same data is requested far more often than it changes
- Adding or tuning a cache layer (in-memory, Redis, HTTP/CDN, client data layer)
- Diagnosing stale data, thundering herd, or invalidation bugs

Don't reach for a cache first — confirm there's a measured read cost ([[perf-budget]]); often a better
query or index ([[data-modeling]]) beats a cache. If the cache sits behind a network call, pair with
[[resilience]] for timeouts and graceful degradation when the cache or origin fails.

## Process

1. **Confirm it's worth caching.** All three must be true: expensive read (measured), read-heavy access
   pattern, and explicitly acceptable staleness. Skip cheap reads, exactness-critical data, and huge
   rarely-reused working sets. See *When to cache* in the reference.
2. **Pick the narrowest layer that fits.** Request memo → process memory → shared cache → HTTP/CDN →
   client — each adds scope and invalidation complexity. Don't stack layers without a reason. See the
   layer table in the reference.
3. **Choose invalidation before writing cache code.** TTL, write-invalidate, versioned keys,
   event-driven purge, or stale-while-revalidate — pick one primary strategy and document what
   "correct again" means. No strategy = don't ship the cache.
4. **Design keys to include every dimension.** Tenant, user, locale, params, version — a key that omits
   one serves wrong or leaked data. Namespace and hash large param sets. See *Cache key design*.
5. **Bound size and prevent stampedes.** Eviction policy (LRU, TTL, max memory) so the cache can't
   grow without limit. Single-flight, TTL jitter, or SWR for hot keys so expiry doesn't crush the
   origin ([[resilience]]).
6. **Apply security rules for shared caches.** No per-user or sensitive data in CDN/public cache without
   scoped keys and correct `Cache-Control`. Treat Redis entries as sensitive if they hold user data
   ([[hardening]]).
7. **Instrument and verify.** Hit rate, miss latency, evictions, stale serves. A low hit rate is cost
   without benefit — remove or fix keys/TTL ([[observability]]). Measure before/after on the hot path.

When debugging stale data: identify the layer, inspect the key, trace every write path for invalidation,
then reproduce with cache bypass. See *Debugging stale-data bugs* in the reference.

## Common Rationalizations

- "Add a cache, it'll be faster." — Without invalidation, users get stale or wrong data; debugging costs more than you saved.
- "TTL of an hour is fine." — Only if an hour of staleness is acceptable to the product; decide explicitly.
- "The key is just the id." — Missing tenant, locale, or version leaks or corrupts data across users.
- "Cache everything." — Cheap or rarely reused data adds complexity and memory for no measured gain.
- "We'll invalidate later." — Every write path you miss stays wrong until TTL; design invalidation first.
- "Redis is fast enough." — A stampede on miss turns Redis into a fuse to your database.

## Red Flags

- Cache added before read cost was measured on the hot path
- No defined invalidation strategy or missed write paths
- Keys missing an input the cached value depends on
- Unbounded in-memory or Redis usage with no eviction
- Personalized responses cached as `public` or under a global key
- Hot key expiry causing origin overload (no single-flight or jitter)
- No hit-rate or miss-latency metrics; stale bugs reported by users first

## Verification

- [ ] Read is measured, read-heavy, expensive, and staleness tolerance is documented
- [ ] Layer matches scope; invalidation strategy is explicit and implemented on all write paths
- [ ] Keys include every dimension; size bounded; stampedes mitigated
- [ ] Shared/CDN cache respects security scoping and Cache-Control rules
- [ ] Hit rate and latency instrumented; before/after numbers justify the cache
- [ ] Reference checklist completed for the change
