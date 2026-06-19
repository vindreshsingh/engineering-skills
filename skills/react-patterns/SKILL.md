---
name: react-patterns
description: Applies performance-minded React and Next.js patterns. Use when writing, reviewing, or refactoring React/Next.js code — components, data fetching, rendering, bundle size, or re-render behaviour.
metadata:
  version: "1.0.0"
---

# React Patterns

Practical rules for writing fast, predictable React and Next.js code. The rules are grouped by the
impact they tend to have, so when you have to choose what to fix first, start at the top.

This skill describes *patterns and principles* in its own words. For deeper background, the React and
Next.js docs are the source of truth (see Further Reading). Treat the examples here as illustrations,
not copy-paste snippets.

## When to Use

- Writing a new component, page, route handler, or server action
- Adding or restructuring data fetching (client or server)
- Reviewing a PR for performance or re-render problems
- A page feels slow: slow first paint, janky typing, large JS bundle, or unnecessary refetching
- Refactoring legacy class/effect-heavy components

## Process

Work top-down. The earlier categories almost always matter more than the later ones.

### 1. Remove request waterfalls (highest impact)

A waterfall is any sequence where request B only starts after request A finishes, even though B did
not need A's result. Each hop adds a full round-trip of latency.

- Kick off independent async work together and await the group, instead of awaiting one at a time.
  Prefer `Promise.all` for fully independent work.
- Cheap synchronous checks (auth role, feature flag already in memory, input validation) belong
  *before* any `await`, so you fail fast without paying for a network call.
- In route handlers and server actions, start the promises early and only `await` them at the point
  you actually consume the value.
- On the server, lean on streaming: wrap slow, non-critical regions in `Suspense` so the shell ships
  immediately and the slow part fills in later.

```jsx
// Avoid: sequential, even though the two reads are unrelated
const user = await getUser(id);
const posts = await getPosts(id);

// Prefer: both in flight at once
const [user, posts] = await Promise.all([getUser(id), getPosts(id)]);
```

### 2. Keep the bundle small (highest impact)

Every kilobyte of JavaScript is downloaded, parsed, and executed before the page is interactive.

- Import the specific module you need rather than pulling a whole barrel/index file that drags in
  unrelated code.
- Load heavy, below-the-fold, or rarely-used components lazily (`next/dynamic` or `React.lazy`).
- Defer non-essential third-party scripts (analytics, chat widgets) until after hydration or first
  interaction.
- Keep import paths statically analyzable so the bundler can tree-shake; avoid dynamic string paths
  the bundler cannot follow.
- Preload on intent — start fetching a route/chunk on hover or focus so it feels instant on click.

### 3. Server-side performance (high)

- Authenticate server actions exactly like API routes; they are public entry points, not trusted
  internals.
- Deduplicate per-request reads with a request-scoped cache so the same data is not fetched twice in
  one render tree.
- Use a cross-request cache (e.g. an LRU) for data that is expensive and changes slowly.
- Send only what the client component actually needs as props — large serialized payloads cost both
  bandwidth and hydration time.
- Never hold request-specific data in module-level mutable variables; modules are shared across
  requests and this leaks data between users.
- Hoist static I/O (font files, logos, config read once) to module scope so it runs once, not per
  request.

### 4. Client-side data fetching (medium-high)

- Use a caching/deduping data layer (such as SWR or React Query) so concurrent components asking for
  the same key share one request.
- Register global listeners (resize, scroll, storage) once and fan out, rather than per component.
- Mark scroll/touch listeners `passive` when you do not call `preventDefault`, so scrolling stays
  smooth.
- Version and trim anything you persist to `localStorage`; validate its shape on read.

### 5. Reduce unnecessary re-renders (medium)

- Do not subscribe a component to state it only reads inside a callback — read it lazily (ref or
  functional updater) instead.
- Derive values during render; do not mirror props into state via an effect.
- Prefer primitive dependencies in `useEffect`/`useMemo`; objects and arrays recreate every render
  and defeat the comparison.
- Initialize expensive `useState` with a function so the work runs once, not on every render.
- Do not define components inside other components — each render makes a new type and remounts the
  subtree.
- Reach for `useTransition`/`useDeferredValue` to keep input responsive while heavy renders catch up.

```jsx
// Avoid: recomputed every render
const [items] = useState(buildExpensiveList());

// Prefer: lazy initializer runs once
const [items] = useState(() => buildExpensiveList());
```

### 6. Rendering performance (medium)

- For long lists, let the browser skip offscreen work with `content-visibility`, and virtualize when
  the list is genuinely large.
- Hoist static JSX out of the render path so it is not recreated each render.
- Use resource hints (`preload`/`preconnect`) for critical assets, and `defer`/`async` on scripts.
- Avoid hydration flicker for client-only values by gating on mount instead of guessing during SSR.

### 7. JavaScript micro-patterns (low-medium)

These matter in hot paths and large loops, not everywhere — measure before micro-optimizing.

- Build a `Map`/`Set` once for repeated lookups instead of scanning an array each time.
- Hoist `RegExp` and other constant constructions out of loops.
- Combine multiple `filter`/`map` passes into a single loop when the data is large.
- Return early to skip work; check `length` before doing expensive comparisons.
- Prefer immutable helpers (`toSorted`, `flatMap`) for clarity without extra passes.

### 8. Advanced (low, situational)

- Keep frequently-changing callbacks stable with refs so children do not re-render on every change.
- Run one-time app initialization exactly once per load, not per mount.
- Be careful not to feed effect-event results into effect dependency arrays.

## Common Rationalizations

- "It's only one extra await." — One serial await is one extra round-trip on the critical path;
  they compound fast.
- "The whole library tree-shakes anyway." — Barrel imports frequently defeat tree-shaking; verify
  with the bundle analyzer, don't assume.
- "Memoizing everything is safer." — Needless `memo`/`useMemo` adds comparison cost and complexity;
  memoize measured-expensive work, not primitives.
- "We'll optimize later." — Waterfalls and bundle bloat are architectural; they get harder to remove
  the longer they live.

## Red Flags

- A chain of `await`s where later calls don't use earlier results
- `import { X } from 'big-lib'` for a single helper, or dynamic import paths the bundler can't trace
- Module-level `let` that stores per-user/request data on the server
- An effect whose only job is copying props into state
- A component defined inside another component's body
- Persisted client state with no version field or shape validation

## Verification

- [ ] Independent async work runs in parallel; cheap checks precede awaits
- [ ] Bundle impact checked (analyzer); heavy/rare code is lazy-loaded
- [ ] Server actions authenticated; no module-level mutable request state
- [ ] Per-request reads deduplicated; client components get minimal props
- [ ] No prop→state mirroring effects; expensive `useState` uses a lazy initializer
- [ ] Typing/interaction stays responsive under load (transitions where needed)
- [ ] Measured before and after — the change is justified by numbers, not vibes

## Further Reading

- React docs — https://react.dev
- Next.js docs — https://nextjs.org
- SWR — https://swr.vercel.app

> These patterns reflect widely-documented React/Next.js performance guidance. Written for this repo;
> not a reproduction of any third-party document.
