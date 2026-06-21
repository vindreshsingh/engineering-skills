---
name: micro-interactions
description: Adds purposeful click feedback and React view transitions without hurting performance or accessibility. Use when implementing button/card press states, route or modal transitions, list reorder animations, or any motion that confirms user action.
---

# Micro-Interactions

Motion should **confirm action and orient the user** — not decorate. A tap that doesn't respond feels
broken; a page that teleports feels disorienting. This skill covers **click/tap micro-feedback** and
**view transitions** in React apps with compositor-safe, accessible motion.

Pair with [[ui-craft]] for interaction quality and states, [[react-patterns]] for Client boundaries and
perf, [[accessibility]] for reduced-motion and focus, [[browser-checks]] to verify in a real browser,
and [[perf-budget]] if animations run on hot paths or large lists.

Run the [micro-interactions checklist](../../references/micro-interactions-checklist.md) before merge.

## When to Use

- Adding press/hover/active feedback to buttons, cards, chips, or icon controls
- Animating route changes, tabs, modals, drawers, or step wizards
- Shared-element or cross-fade transitions between two views (list → detail)
- Replacing jarring instant swaps with short, purposeful motion
- Reviewing PRs where motion was added ad hoc or blocks interaction

**Skip** as primary skill when there is no interactive UI (pure API, batch jobs). **Not a substitute
for** [[ui-craft]] — motion sits on top of correct structure and states.

| Situation | Lead skill |
|-----------|------------|
| General UI build + states | [[ui-craft]] → **micro-interactions** for motion |
| React perf / RSC boundaries | [[react-patterns]] |
| WCAG, focus, screen readers | [[accessibility]] |
| Click feedback + page transition on same feature | **micro-interactions** |

## Process

Work in order. Spec motion before sprinkling CSS.

### 1. Define the motion intent

For each interactive surface, write one line:

- **Trigger** — click, tap, keyboard activate, route enter, modal open
- **Purpose** — confirm press, show progress, maintain context, guide attention
- **Duration target** — micro-feedback: 100–200ms; view transition: 200–350ms; never >500ms for UI chrome

If you cannot state the purpose, skip the animation.

### 2. Respect reduced motion first

Before any implementation:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

Or gate motion in JS:

```js
const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
```

Rules:

- **Never** rely on motion alone to convey state (pair with color, text, icon, or aria-live)
- Under reduced motion: instant swap or opacity-only cross-fade — no scale/bounce travel
- Document motion behavior in the component or handoff notes ([[design-handoff]])

### 3. Click and tap micro-feedback

Prefer **CSS-first** on the interactive element itself — no extra libraries for a button press.

**Do:**

- `:active` or `data-pressed` with `transform: scale(0.97)` and `transition: transform 120ms ease-out`
- `:hover` only on devices that support hover (`@media (hover: hover)`)
- `transition` on **transform** and **opacity** only (compositor-friendly)
- Keep hit target ≥44×44px; motion must not shrink the clickable area below that

**Don't:**

- Animate `width`, `height`, `top`, `left`, `margin`, or `box-shadow` spread on every click (layout/paint cost)
- Block the click handler waiting for animation to finish
- Use long spring animations on primary actions (feels sluggish)

```css
.button {
  transition: transform 120ms ease-out, opacity 120ms ease-out;
}
.button:active {
  transform: scale(0.97);
}
@media (hover: hover) {
  .button:hover {
    opacity: 0.9;
  }
}
```

For loading after click: disable + spinner or progress — see [[ui-craft]] submit feedback.

### 4. Choose a view-transition strategy

Pick **one** approach per navigation pattern; don't mix APIs on the same route without reason.

| Pattern | Approach |
|---------|----------|
| Full page / route change (App Router) | View Transitions API via framework support or `document.startViewTransition` |
| Tab or segmented control | CSS cross-fade between panels; optional `view-transition-name` on active tab |
| Modal / drawer | Enter/exit on overlay + panel (`transform` + `opacity`); trap focus ([[accessibility]]) |
| List → detail shared element | Named `view-transition-name` on thumbnail/title in both views |

**View Transitions API (browser-native):**

```js
function navigate(updateDOM) {
  if (!document.startViewTransition) {
    updateDOM();
    return;
  }
  document.startViewTransition(() => updateDOM());
}
```

In React, call `startViewTransition` around the state update that swaps DOM (route content, tab panel,
modal body). Assign stable `view-transition-name` only to elements that should morph — one name per
logical shared element.

**Next.js App Router:** enable view transitions in framework config when available; use `<Link>` with
view transition support rather than hand-rolling per link. Fall back to instant navigation when API
unsupported.

**React `<ViewTransition>` (when available in your React version):** wrap the conditional branch that
changes on navigation; treat as experimental — verify bundle and behavior in target browsers.

**Avoid by default:** pulling in Framer Motion / Motion for every button — use only if the project
already standardizes on it and bundle budget allows ([[perf-budget]]).

### 5. Implement with correct React boundaries

- Micro-interactions on **`'use client'` leaves** — not entire page shells ([[react-patterns]])
- Route transition wrapper: one client boundary at the layout or transition provider level, not per leaf
- Don't animate Server Component output directly — animate the client wrapper or use View Transitions
  on the document swap after navigation
- List animations: prefer **one** transitioning item (enter/exit), not animating 100 rows on mount

### 6. Timing, easing, and concurrency

| Type | Duration | Easing |
|------|----------|--------|
| Press feedback | 80–150ms | `ease-out` |
| Hover hint | 150–200ms | `ease-out` |
| View enter/exit | 200–350ms | `ease-in-out` or custom cubic-bezier |
| Stagger (lists) | ≤30ms between items | cap total stagger |

- **One motion at a time** on primary CTA — don't stack scale + ripple + color + shadow
- **`pointer-events: none`** on exiting overlay during transition only if clicks are truly blocked
- Cancel in-flight transitions when user navigates again — don't queue animations

### 7. Verify in browser

Before merge ([[browser-checks]]):

- Click/tap primary actions — feedback visible within one frame of release
- Tab + Enter — same feedback as click (not hover-only)
- Enable **prefers-reduced-motion** in OS — motion reduces or disappears; UI still usable
- Route/modal transition — no focus trap broken, no content flash before transition
- Throttle CPU 4× — transitions stay smooth or degrade to instant (no jank loop)
- Mobile: no `:hover` stuck states; touch feedback works

## Common Rationalizations

- "Motion makes it feel premium." — Premium is **fast and responsive**; slow bounce feels cheap.
- "We'll add reduced-motion later." — Later ships inaccessible UI; gate from line one.
- "Framer Motion for everything." — Bundle and abstraction cost; CSS + View Transitions cover most cases.
- "Animate width so the layout grows nicely." — Use transform scale or reserve space; layout animation is expensive.
- "200ms delay before navigate feels smoother." — Delay blocks the user; animate *during* navigation, don't delay it.
- "Only designers care about press states." — Users notice dead clicks; it's core [[ui-craft]] feedback.

## Red Flags

- Click handler `await`s animation before side effect
- `:hover` styles on touch-only devices with no `:active` fallback
- `prefers-reduced-motion` not handled
- Animating layout properties on lists with many items
- View transition without fallback when API missing
- Focus lost after route transition ([[accessibility]])
- Motion is the only indicator of success/error
- `'use client'` on whole page for one button scale effect
- Transition duration >500ms on standard UI chrome
- Identical `view-transition-name` on multiple elements in the same view

## Verification

- [ ] Motion intent documented (trigger, purpose, duration) per surface
- [ ] `prefers-reduced-motion` respected — instant or minimal alternative
- [ ] Click/tap uses transform/opacity; handler not blocked by animation
- [ ] Hover styles gated with `@media (hover: hover)` where needed
- [ ] View transitions use one chosen strategy with API fallback
- [ ] Client boundaries minimal ([[react-patterns]])
- [ ] Keyboard activation gets same feedback as pointer
- [ ] Checked in browser — mobile, reduced motion, slow CPU ([[browser-checks]])
- [ ] No layout-thrashing properties animated on hot paths
- [ ] Deep a11y/custom widgets coordinated with [[accessibility]] when applicable
