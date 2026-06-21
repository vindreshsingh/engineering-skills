---
name: react-patterns
description: Applies performance-minded React and Next.js patterns. Use when writing, reviewing, or refactoring React/Next.js code — components, Server/Client boundaries, data fetching, rendering, bundle size, re-renders, forms, or streaming.
---

# React Patterns

Practical rules for writing fast, predictable React and Next.js code. Patterns are grouped by impact so
when you have to choose what to fix first, start at the top. Most slowness in React apps is
architectural — waterfalls, wrong boundaries, bundle bloat — not missing `memo` on a leaf component.

This skill describes *patterns and principles* in its own words. For deeper background, the React and
Next.js docs are the source of truth (see Further Reading). Treat the examples here as illustrations,
not copy-paste snippets.

Run the [react patterns checklist](../../references/react-patterns-checklist.md) alongside this process
for a quick pass. Pair with [[perf-budget]] to measure before optimizing, [[browser-checks]] to verify
in a real browser, [[ui-craft]] for interaction quality, [[micro-interactions]] for press states and
view transitions, [[caching-strategy]] when adding cross-request
caches, and [[accessibility]] when patterns affect focus or announcements.

## When to Use

- Writing a new component, page, route handler, or server action
- Choosing Server vs Client Components or moving data fetching
- Adding or restructuring data fetching (RSC, client cache, mutations)
- Reviewing a PR for performance, re-render, or hydration problems
- A page feels slow: slow first paint, janky typing, large JS bundle, unnecessary refetching, or layout shift
- Refactoring legacy class/effect-heavy components or Pages Router code
- Implementing forms, optimistic UI, or streaming loading states

**Skip** as the primary skill when the change has no React/Next surface (pure SQL, CLI, unrelated backend).
**Not a substitute for** [[perf-budget]] — profile and set a budget before micro-optimizing.

## Process

Work top-down. The earlier categories almost always matter more than the later ones.

### 0. Place the Server/Client boundary correctly

In the App Router, **Server Components are the default**. A Client Component (`'use client'`) is needed
only when the tree uses interactivity, browser-only APIs, or state/effect hooks.

| Put on the server | Keep on the client |
|-------------------|-------------------|
| Data fetching, secrets, DB/API calls | `onClick`, `onChange`, drag-and-drop |
| Large dependencies that never need the browser | `useState`, `useEffect`, most hooks |
| Static or slow-changing markup | Browser APIs (`localStorage`, `window`, observers) |
| Streaming via `Suspense` | Third-party widgets that require the DOM |

Rules:

- **Push `'use client'` to the leaves** — a small interactive island, not the whole page wrapper.
- **Never import server-only code into a Client Component** — no DB clients, env secrets, or
  `server-only` modules in client bundles.
- **Pass serializable props across the boundary** — functions, class instances, and Dates don't
  serialize cleanly; pass IDs and plain data, fetch or mutate on the correct side.
- **Colocate fetching with the component that consumes the data** — don't fetch in a parent and drill
  props through five layers when a Server Component child can fetch directly.

```jsx
// Prefer: page shell is server; button is a small client leaf
export default async function Page() {
  const data = await getData(); // server
  return (
    <>
      <StaticSummary data={data} />
      <LikeButton itemId={data.id} /> {/* 'use client' inside */}
    </>
  );
}
```

### 1. Remove request waterfalls (highest impact)

A waterfall is any sequence where request B only starts after request A finishes, even though B did
not need A's result. Each hop adds a full round-trip of latency.

- Kick off independent async work together and await the group — prefer `Promise.all` for fully
  independent work.
- Cheap synchronous checks (auth role, feature flag in memory, input validation) belong *before* any
  `await`, so you fail fast without paying for a network call.
- In route handlers and server actions, **start promises early** and only `await` at the point you
  consume the value.
- In layouts/pages, don't `await` parent data before starting child fetches that don't depend on it —
  parallelize across the tree with separate async Server Components wrapped in `Suspense`.
- On the server, lean on **streaming**: wrap slow, non-critical regions in `Suspense` so the shell
  ships immediately and the slow part fills in later.

```jsx
// Avoid: sequential, even though the two reads are unrelated
const user = await getUser(id);
const posts = await getPosts(id);

// Prefer: both in flight at once
const [user, posts] = await Promise.all([getUser(id), getPosts(id)]);
```

```jsx
// Avoid: child waits for parent await before its fetch starts
export default async function Page() {
  const header = await getHeader();
  return (
    <>
      <Header data={header} />
      <SlowFeed /> {/* async inside, but only mounts after header resolves */}
    </>
  );
}

// Prefer: stream independent regions
export default function Page() {
  return (
    <>
      <Suspense fallback={<HeaderSkeleton />}>
        <Header />
      </Suspense>
      <Suspense fallback={<FeedSkeleton />}>
        <SlowFeed />
      </Suspense>
    </>
  );
}
```

### 2. Keep the bundle small (highest impact)

Every kilobyte of JavaScript is downloaded, parsed, and executed before the page is interactive.

- Import the **specific module** you need — avoid barrel/index files that drag unrelated code into the
  chunk.
- Load heavy, below-the-fold, or rarely-used UI with `next/dynamic` or `React.lazy`; use `{ ssr: false }`
  only when the component truly cannot render on the server.
- Defer non-essential third-party scripts (analytics, chat widgets) until after hydration or first
  interaction (`next/script` with `strategy="lazyOnload"` or on user intent).
- Keep import paths **statically analyzable** so the bundler can tree-shake; avoid dynamic string paths
  the bundler cannot follow.
- **Preload on intent** — prefetch routes with `<Link prefetch>` (default in viewport) or on hover/focus
  for heavy navigations.
- Audit with the bundle analyzer ([[perf-budget]]) — assumptions about tree-shaking are often wrong.

```jsx
// Avoid: pulls entire icon library
import { Icon } from '@/components/icons';

// Prefer: direct import
import { CheckIcon } from '@/components/icons/CheckIcon';
```

### 3. Server-side performance (high)

- **Authenticate server actions** exactly like API routes — they are public entry points, not trusted
  internals ([[hardening]]).
- **Deduplicate per-request reads** with `React.cache()` (or equivalent request-scoped memo) so the
  same data is not fetched twice in one render tree.
- Use a **cross-request cache** ([[caching-strategy]]) — `fetch` with `next: { revalidate }`, cache
  tags, or framework cache helpers — for data that is expensive and changes slowly. Document
  invalidation (`revalidateTag`, `revalidatePath`) on every write path.
- Send only what the Client Component **actually needs** as props — large serialized payloads cost
  bandwidth and hydration time.
- **Never hold request-specific data in module-level mutable variables** — modules are shared across
  requests and leak data between users.
- Hoist **static I/O** (font files, logos, config read once) to module scope so it runs once, not per
  request.
- Prefer **`notFound()` / `redirect()`** at the data layer over fetching then conditionally rendering
  empty states for missing resources — fail fast on the server.

```jsx
import { cache } from 'react';

// Deduped within a single request/render pass
export const getUser = cache(async (id: string) => {
  return db.user.findUnique({ where: { id } });
});
```

### 4. Client-side data fetching (medium-high)

- **Don't fetch in `useEffect` what a Server Component can fetch** — client fetching is for live updates,
  user-specific post-hydration data, or polling — not the initial page payload.
- Use a **caching/deduping data layer** (SWR, TanStack Query) so concurrent components asking for the
  same key share one request; configure `staleTime`/`gcTime` explicitly.
- **Register global listeners once** (resize, scroll, storage) and fan out — not one listener per
  component instance.
- Mark scroll/touch listeners **`passive`** when you do not call `preventDefault`, so scrolling stays
  smooth.
- **Version and trim** anything persisted to `localStorage`; validate shape on read — corrupt storage
  should not crash the tree.
- Cancel or ignore **stale responses** when inputs change (AbortController, query library built-ins).

### 5. State colocation and re-render control (medium)

- **Colocate state** with the component that uses it — lift only when siblings truly need to share it.
  URL/search params are ideal for shareable, bookmarkable UI state.
- Do not subscribe a component to state it only reads **inside a callback** — read lazily (ref or
  functional updater) instead.
- **Derive values during render**; do not mirror props into state via an effect.
- Prefer **primitive dependencies** in `useEffect`/`useMemo`; objects and arrays recreated every render
  defeat comparison and retrigger effects.
- Initialize expensive `useState` with a **function** so the work runs once, not on every render.
- Do not define **components inside other components** — each render creates a new type and remounts the
  subtree.
- Reach for **`useTransition` / `useDeferredValue`** to keep input responsive while heavy renders catch
  up — prefer these over manual debounce for render-bound work.
- **`memo` / `useMemo` / `useCallback`** only on measured-expensive paths — they add comparison cost;
  don't wrap every primitive prop.
- Split **Context** by concern or pass stable selectors — one big context value re-renders every consumer
  on any field change.

```jsx
// Avoid: recomputed every render
const [items] = useState(buildExpensiveList());

// Prefer: lazy initializer runs once
const [items] = useState(() => buildExpensiveList());
```

```jsx
// Avoid: effect mirrors props → state
useEffect(() => { setCount(initialCount); }, [initialCount]);

// Prefer: derive, or reset with a key on the parent
const count = deriveCount(props);
// or <Counter key={userId} initialCount={initialCount} />
```

### 6. Rendering and hydration (medium)

- For long lists, use **`content-visibility: auto`** for offscreen rows and **virtualize** when the list
  is genuinely large (thousands) — measure before adding virtualization complexity.
- Use **stable, unique keys** from data (`id`), not array index, when items reorder, insert, or delete.
- Hoist **static JSX** out of the render path so it is not recreated each render.
- Use resource hints (`preload`/`preconnect`) for critical assets; `defer`/`async` on scripts.
- Avoid **hydration mismatch**: don't render client-only values (random IDs, `Date.now()`, `window`
  size) during SSR — gate on mount or use `suppressHydrationWarning` only for known-safe text (e.g.
  timestamps).
- **Loading UI must reserve space** — skeletons with fixed dimensions beat spinners that collapse and
  cause layout shift ([[ui-craft]], [[browser-checks]]).

### 7. Forms, mutations, and optimistic UI (medium)

- Prefer **Server Actions** for mutations when using the App Router — progressive enhancement works
  without JS; still validate and authorize server-side.
- Return **structured errors** from actions (field-level + form-level) and surface them with
  `useActionState` — don't rely on thrown errors alone for expected validation failures.
- Call **`revalidateTag` / `revalidatePath`** (or equivalent) on every successful write that affects
  cached reads — missing invalidation is a stale-data bug ([[caching-strategy]]).
- Use **`useOptimistic`** for instant feedback on adds/toggles/deletes; reconcile when the server
  responds — roll back on failure with a clear message.
- **Disable double-submit** — pending state on the submit button or action, not just hope.

```jsx
'use client';

async function action(prevState, formData) {
  'use server';
  // validate, authorize, mutate, revalidateTag('items')
  return { ok: true };
}
```

### 8. Effects — synchronization only (medium)

Effects are for **syncing with external systems** (DOM subscriptions, network bridges, non-React widgets)
— not for transforming data or responding to user events.

| Use an effect for | Don't use an effect for |
|-------------------|-------------------------|
| Subscribing to external store/event | Deriving state from props/state |
| Integrating non-React library | Handling clicks/submits (event handlers) |
| Syncing with browser API after mount | Fetching data RSC can fetch on first paint |
| Logging/analytics side channel | Resetting state when props change (use key) |

- Always **clean up** subscriptions, timers, and listeners in the effect return.
- For logic that must read latest props/state inside an effect without re-subscribing, use the
  **Effect Event** pattern (`useEffectEvent` in React 19+) — don't omit dependencies that should
  trigger re-sync.
- **Strict Mode double-mount** in dev is intentional — effects must be idempotent and cleanup-safe.

### 9. Suspense, errors, and loading boundaries (medium)

- Wrap **async Server Components** in `Suspense` with a meaningful fallback — the fallback is what users
  see during streaming; make it structurally similar to the final UI.
- Use route-level **`loading.js`** for whole-segment defaults; use inline `Suspense` when only part of
  the page is slow.
- **`error.js`** (Client Component) catches render errors in a segment — pair with a recovery action
  (retry, go home); log the error server-side ([[observability]]).
- **Error boundaries don't catch** event-handler errors or server action failures — handle those in the
  action/handler and return user-visible errors.
- Nested Suspense boundaries let **fast regions paint first** — don't wrap the entire page in one boundary
  waiting for the slowest query.

### 10. JavaScript micro-patterns (low-medium)

These matter in hot paths and large loops — measure before micro-optimizing ([[perf-budget]]).

- Build a **`Map`/`Set` once** for repeated lookups instead of scanning an array each time.
- Hoist **`RegExp`** and other constant constructions out of loops.
- Combine multiple **`filter`/`map` passes** into a single loop when the data is large.
- Return early to skip work; check `length` before expensive comparisons.
- Prefer immutable helpers (`toSorted`, `flatMap`) for clarity without extra passes.

### 11. Advanced (low, situational)

- Keep frequently-changing callbacks **stable with refs** so memoized children don't re-render on every
  parent render.
- Run **one-time app initialization** exactly once per load (module scope or dedicated bootstrap), not
  per mount in every root component.
- Be careful not to feed **Effect Event** results into effect dependency arrays — they are not
  dependencies.
- When the **React Compiler** is enabled, manual `memo`/`useMemo` may be redundant — still apply
  architectural patterns (boundaries, waterfalls, bundle size); verify with profiler, don't delete all
  memoization blindly.

## Common Rationalizations

- "It's only one extra await." — One serial await is one extra round-trip on the critical path; they
  compound fast across layout, page, and child components.
- "The whole library tree-shakes anyway." — Barrel imports frequently defeat tree-shaking; verify with
  the bundle analyzer, don't assume.
- "Memoizing everything is safer." — Needless `memo`/`useMemo` adds comparison cost and complexity;
  memoize measured-expensive work, not primitives.
- "We'll optimize later." — Waterfalls and bundle bloat are architectural; they get harder to remove
  the longer they live.
- "This page needs `'use client'` at the top." — One hook or click handler rarely justifies shipping the
  entire page as client JS; split into a leaf.
- "I'll fetch in `useEffect` — it's simpler." — You pay with an extra client round-trip, loading flash,
  and no SSR for that data.
- "Effects keep things in sync." — Most "sync" effects are derived state or event logic in disguise;
  remove the effect and the bug class goes away.
- "Index as key is fine here." — Fine until insert, delete, or reorder — then state lands on the wrong
  row and bugs are subtle.

## Red Flags

- A chain of `await`s where later calls don't use earlier results
- `'use client'` on a page/layout that is mostly static data and markup
- Server-only imports reachable from a Client Component bundle
- `import { X } from 'big-lib'` for a single helper, or dynamic import paths the bundler can't trace
- Module-level `let` storing per-user/request data on the server
- An effect whose only job is copying props into state or transforming already-available data
- A component defined inside another component's body
- `useEffect(() => { fetch(...) }, [])` for initial page data a Server Component could fetch
- Persisted client state with no version field or shape validation
- Mutations with no cache revalidation or tag invalidation story
- Hydration warnings in the console ([[browser-checks]])
- Loading spinners with no reserved height — content jumps when data arrives
- One Context provider holding unrelated fast-changing and slow-changing state together

## Verification

- [ ] Server/Client boundary is at the leaves; no server secrets in client bundles
- [ ] Independent async work runs in parallel; cheap checks precede awaits; slow regions stream via Suspense
- [ ] Bundle impact checked (analyzer); heavy/rare code is lazy-loaded; barrel imports avoided
- [ ] Server actions authenticated; no module-level mutable request state; writes invalidate cached reads
- [ ] Per-request reads deduplicated; Client Components receive minimal serializable props
- [ ] No prop→state mirroring effects; expensive `useState` uses a lazy initializer
- [ ] Effects are for external sync only — no fetch-on-mount for data RSC can provide
- [ ] Forms/mutations handle pending, error, and double-submit; optimistic UI rolls back on failure
- [ ] Loading/error boundaries in place; fallbacks match layout to avoid shift
- [ ] Typing/interaction stays responsive under load (transitions where needed)
- [ ] Measured before and after ([[perf-budget]]) — the change is justified by numbers, not vibes
- [ ] Checklist in [react patterns checklist](../../references/react-patterns-checklist.md) completed for the change

## Further Reading

- React docs — https://react.dev
- Next.js App Router — https://nextjs.org/docs/app
- React Server Components — https://react.dev/reference/rsc/server-components
- SWR — https://swr.vercel.app
- TanStack Query — https://tanstack.com/query

> These patterns reflect widely-documented React/Next.js performance and architecture guidance. Written
> for this repo; not a reproduction of any third-party document.
