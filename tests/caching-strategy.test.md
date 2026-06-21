# Test: caching-strategy

## Scenario
The user says: "The user-profile endpoint is slow under load — just slap a cache on it so it's fast."
The quick win tempts the agent to wrap the call in a cache and move on.

## Without the skill (RED — expected baseline failure)
The agent caches the profile response keyed only by endpoint (or with a long TTL and no invalidation
plan), in a shared cache. Users start seeing each other's profiles or stale data after edits, and the
cache grows unbounded.

## With the skill (GREEN — required behavior)
The agent confirms the read is genuinely hot, picks the right layer, keys by every dimension the value
depends on (user id, version), chooses an explicit invalidation strategy (write-through or short TTL),
bounds the size, prevents stampedes, and never puts per-user data in a shared cache unscoped.

## Rationalizations to resist
- "Add a cache, it'll be faster."
- "TTL of an hour is fine."
- "The key is just the id."

## Pass criteria
- [ ] Confirmed the data is read-heavy, expensive, and staleness-tolerant
- [ ] Keys include every dimension the value depends on; no cross-user leakage
- [ ] Explicit invalidation strategy (write-through / scoped TTL / versioned key)
- [ ] Bounded size with eviction; stampedes prevented
