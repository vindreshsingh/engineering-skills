# React Patterns Checklist

A quick checklist to run alongside the [[react-patterns]] skill. Always **measure before and after**
([[perf-budget]]) — nothing here is worth doing on a path that isn't actually hot.

## Boundaries & Architecture

- [ ] Server Components are the default; `'use client'` only where interactivity or browser APIs require it
- [ ] Client boundary pushed to leaves — not the whole page wrapper
- [ ] No server-only modules, secrets, or DB clients imported into Client Components
- [ ] Props across the boundary are serializable; functions and class instances aren't passed blindly
- [ ] Data fetching colocated with the component that consumes the data

## Data Fetching & Waterfalls

- [ ] Independent async work runs in parallel (`Promise.all` or parallel Suspense regions)
- [ ] Cheap sync checks (auth, validation) run before any `await`
- [ ] Slow regions wrapped in `Suspense` so the shell streams immediately
- [ ] Per-request reads deduplicated (`React.cache` or equivalent)
- [ ] Cross-request cache has explicit invalidation on every write path ([[caching-strategy]])
- [ ] Client `useEffect` fetch isn't used for initial page data a Server Component can fetch

## Bundle & Assets

- [ ] Bundle impact checked with an analyzer; no surprise barrel imports
- [ ] Heavy or rare UI lazy-loaded (`next/dynamic` / `React.lazy`)
- [ ] Third-party scripts deferred until after hydration or user intent
- [ ] Import paths are statically analyzable for tree-shaking
- [ ] Routes/chunks prefetched on intent where navigation feels slow

## Re-renders & State

- [ ] State colocated; lifted only when siblings share it; URL used for shareable UI state
- [ ] No prop→state mirroring effects; derived values computed during render
- [ ] Expensive `useState` uses a lazy initializer
- [ ] No components defined inside other components
- [ ] `memo`/`useMemo`/`useCallback` only on measured-expensive paths
- [ ] Context split or scoped so unrelated updates don't broadcast to all consumers
- [ ] Input stays responsive under load (`useTransition` / `useDeferredValue` where needed)

## Rendering & Hydration

- [ ] Long lists virtualized or use `content-visibility` when offscreen work is costly
- [ ] Stable keys from data — not array index when items reorder
- [ ] No hydration mismatch from client-only values rendered on the server
- [ ] Loading skeletons reserve space — no layout shift when content arrives ([[ui-craft]])

## Forms & Mutations

- [ ] Server actions validate and authorize server-side ([[hardening]])
- [ ] Structured field/form errors returned and displayed (`useActionState`)
- [ ] Cache/tags revalidated after successful mutations
- [ ] Optimistic UI rolls back on failure with a clear message
- [ ] Double-submit prevented via pending state

## Effects & Errors

- [ ] Effects used for external sync only — not derived state or event logic
- [ ] Subscriptions, timers, and listeners cleaned up on unmount
- [ ] `error.js` / error boundaries cover segment failures; handler errors handled explicitly
- [ ] Suspense fallbacks structurally match final UI

## After

- [ ] Before/after numbers confirm the change helped ([[perf-budget]])
- [ ] Verified in a real browser — console clean, network sensible ([[browser-checks]])
- [ ] Trade-offs (complexity, cache staleness) justified by measured gain
