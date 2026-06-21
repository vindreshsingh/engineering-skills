# Caching Patterns

Supplementary patterns for the [[caching-strategy]] skill. That skill covers *when* and *how* to
decide on caching; this is the detailed reference — layers, invalidation, keys, HTTP headers,
stampede prevention, and security. Always confirm the read is worth caching first ([[perf-budget]]);
often a better query or index ([[data-modeling]]) removes the need entirely.

## When to cache (and when not to)

**Cache when all three are true:**

- The read is **expensive** — slow query, remote API, heavy computation (measured, not assumed).
- It is **read-heavy** — same data requested far more often than it changes.
- **Bounded staleness is acceptable** — you can state how stale is OK and how correctness is restored.

**Don't cache when:**

- The read is already fast or cheap.
- Data must always be **exact** (balances, permissions, inventory at checkout, auth tokens).
- The working set is huge and rarely reused — you'll miss constantly and waste memory.
- You don't yet know **what invalidates** the value — design invalidation first, then cache.

## Pick the right layer

Choose the narrowest layer that matches scope and freshness needs.

| Layer | Scope | Typical use | Invalidation |
|-------|-------|-------------|--------------|
| **Request-scoped memo** | Single request/handler | Deduping repeated reads in one render tree | Request ends |
| **Process in-memory** (LRU/Map) | One instance | Hot config, compiled templates, local aggregates | TTL, size eviction, restart |
| **Shared cache** (Redis, Memcached) | All app instances | Session-adjacent data, rate limits, cross-request hot reads | TTL, explicit delete, pub/sub |
| **Database query cache / materialized view** | DB layer | Expensive aggregations, dashboards | Refresh job, trigger, version column |
| **HTTP / CDN / browser** | Edge or client | Static assets, public GET APIs, HTML fragments | Cache-Control, ETag, purge API |
| **Client data layer** (SWR, React Query) | Browser tab | API responses, paginated lists | Stale-while-revalidate, mutation invalidation |

Higher layers are faster but harder to invalidate consistently. Don't stack redundant caches without
a reason — each layer needs its own invalidation story.

## Invalidation strategies

Invalidation is the hard part. Decide it **before** writing cache code.

### TTL / expiry

- Simplest: key expires after N seconds.
- Staleness is **bounded** by TTL — state explicitly whether that's acceptable.
- Use **jitter** on TTL (`base + random(0, 10%)`) so keys don't all expire at once (stampede).
- Good for: config, feature flags, reference data, CDN assets.

### Write-through / write-invalidate

- On every write that changes data, **update or delete** the cache entry in the same flow.
- Freshness is strong when writes are infrequent and you control all write paths.
- **Every write path must invalidate** — one missed path = stale forever until TTL.
- Good for: entity detail pages, user profile, settings updated via your API.

### Versioned / content-addressed keys

- Include a **version, etag, or updated_at** in the cache key: `product:{id}:v{version}`.
- Old keys die naturally via TTL; no delete storm on bulk updates.
- Good for: content that changes atomically, CMS pages, compiled artifacts.

### Event-driven invalidation

- Publish invalidation events (message bus, Redis pub/sub) when data changes.
- Subscribers delete or refresh affected keys.
- Good for: multi-service systems where the writer isn't the reader.
- Watch for: missed events, ordering, eventual consistency windows.

### Stale-while-revalidate (SWR)

- Serve stale value immediately; refresh in background for next request.
- Improves latency under load; user may see briefly stale data by design.
- Good for: dashboards, feeds, non-critical aggregates, CDN/browser caching.

## Cache key design

A key that omits a dimension serves **wrong data** — including another user's.

**Include every input the value depends on:**

- Entity id, tenant/org id, user id (when user-scoped)
- Locale, currency, feature flags affecting output
- Query params, filter hash, pagination cursor (when they change the payload)
- Schema or content version

**Conventions:**

- Use a **namespace prefix**: `user:123:profile`, `tenant:acme:report:daily`.
- Prefer **deterministic serialization** of params (sorted keys, stable hash).
- Document key shapes — ad-hoc keys become undebuggable.
- Set a **max key length**; hash large param blobs.

**Anti-patterns:**

- `cache.get(id)` when value depends on tenant, role, or locale.
- One global key for "the config" when config varies per environment or tenant.
- Caching the result of a query without including the full filter set in the key.

## Stampede / thundering herd prevention

When a hot key expires or is cold, every caller may recompute at once and overwhelm the origin.

**Mitigations:**

- **Single-flight / request coalescing** — only one recomputation per key; others wait on the same promise/lock.
- **Probabilistic early expiry** — refresh before hard TTL (each read has small chance to refresh).
- **Stale-while-revalidate** — serve stale while one worker refreshes.
- **TTL jitter** — spread expirations across time.
- **Circuit breaker on origin** — don't hammer DB when cache is down ([[resilience]]).

## HTTP and CDN caching

For cacheable HTTP responses (especially GET):

| Header | Purpose |
|--------|---------|
| `Cache-Control: public, max-age=3600` | CDN/browser may cache 1 hour |
| `Cache-Control: private, no-store` | User-specific; never shared cache |
| `Cache-Control: no-cache` | Must revalidate with origin before use |
| `ETag` / `If-None-Match` | Conditional GET — 304 when unchanged |
| `Vary: Accept-Encoding, Accept-Language` | Separate cache entries per variant |

**Rules:**

- **Never** mark personalized or authenticated responses `public` unless the URL + headers fully scope
  the user ([[hardening]]).
- Use **`private`** for browser-only caching of user-specific data.
- **`no-store`** for sensitive data (health, payment, PII) even on GET.
- Purge CDN by URL or tag when content changes; don't rely on TTL alone for urgent corrections.

## Application cache (Redis / in-memory)

- **Set max memory + eviction policy** (e.g. `allkeys-lru`) — unbounded caches OOM the process.
- **Serialize safely** — version your blob format; handle corrupt entries (delete and miss).
- **Timeout cache calls** — a hung Redis is still a dependency ([[resilience]]).
- **Don't cache errors** unless intentional (short negative cache for known-missing keys).
- **Negative caching**: cache "not found" briefly to protect origin from repeat misses — keep TTL short.

## Client-side caching

- Libraries like SWR/React Query: set **`staleTime`** (fresh window) vs **`gcTime`** (retained after unused).
- **Invalidate on mutation** — after POST/PUT/DELETE, invalidate or update affected query keys.
- **Optimistic updates** need rollback on failure; don't leave stale client cache as source of truth.
- **Don't cache secrets** in localStorage/sessionStorage without understanding XSS exposure.

## Security and privacy

- **Shared caches (Redis, CDN) must not store one user's data under another user's key.**
- Scope keys by **tenant and user** when data is not global.
- Don't cache **auth tokens, session payloads, or PII** in CDN or logs.
- Treat cache contents as **sensitive at rest** if they hold user data — encrypt Redis in transit/at rest in prod.

## Observability

Instrument before tuning:

- **Hit rate** — hits / (hits + misses). Low rate = wrong keys, TTL too short, or shouldn't cache.
- **Latency** — p50/p95 for hit vs miss; miss path must stay bounded.
- **Eviction rate** — memory pressure?
- **Stale serves** — if using SWR, track how often stale is returned.
- **Invalidation failures** — writes that didn't clear/update cache.

Alert on hit-rate collapse or miss latency spikes — often the first sign of stampede or origin overload.

## Debugging stale-data bugs

1. **Identify the layer** — browser, CDN, app memory, Redis, DB replica lag?
2. **Read the key** — does it include every dimension? Dump key + TTL + value hash.
3. **Trace the write path** — did invalidation run on *all* code paths that mutate?
4. **Check clock skew and TTL** — expired early/late?
5. **Reproduce with cache bypass** — `Cache-Control: no-cache` or skip Redis; if correct, it's caching.

## Checklist

### Before adding a cache

- [ ] Read cost measured on the hot path ([[perf-budget]]).
- [ ] Read-heavy, expensive, and staleness tolerance defined in writing.
- [ ] Invalidation strategy chosen (TTL / write-invalidate / versioned / event / SWR).
- [ ] Non-cache alternatives ruled out (index, query rewrite, batching).

### Design

- [ ] Layer matches scope (request / process / shared / HTTP / client).
- [ ] Keys include every dimension the value depends on (tenant, user, locale, version).
- [ ] Bounded size and eviction policy for in-memory and Redis.
- [ ] Stampede mitigation for hot keys (single-flight, jitter, SWR).
- [ ] Timeouts on cache dependency calls.

### Security

- [ ] No per-user data in shared/CDN cache without scoped keys and `private`/`no-store` as appropriate.
- [ ] Sensitive data not cached in public layers.

### Operations

- [ ] Hit rate, miss latency, and evictions instrumented ([[observability]]).
- [ ] All write paths invalidate or version keys.
- [ ] Runbook for emergency purge / disable cache.
- [ ] Before/after latency confirmed; low hit rate investigated or cache removed.
