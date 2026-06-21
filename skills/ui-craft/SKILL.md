---
name: ui-craft
description: Builds correct, responsive, polished front-end UI with every state handled. Use when creating or changing components, layouts, forms, or any user-facing interface — and when reviewing UI for quality before merge.
---

# UI Craft

Good UI is **correct, responsive, and resilient under real conditions** — empty, loading, error,
overflow, and slow network included. The happy-path mockup is the easy 60%; the rest is the craft.
Polish without correctness is lipstick; correctness without states is a demo, not a product.

UI craft is **structure, states, system, and feedback** — not pixel-perfect hero screenshots alone.
Deep accessibility (WCAG, custom widgets, audits) lives in [[accessibility]]; translating mockups lives
in [[design-handoff]]. This skill is the build-quality bar every UI change should meet.

Pair with [[browser-checks]] to verify in a real browser, [[react-patterns]] for React/Next performance,
[[micro-interactions]] for click feedback and view transitions,
[[spec-first]] when behavior is ambiguous, [[ui-craft]] → [[accessibility]] for compliance-sensitive
surfaces, and [[review-gate]] before merge.

## When to Use

- Building or changing any user-facing component, page, form, or layout
- Reviewing front-end work for quality (not just "looks like the mockup")
- Fixing visual bugs, responsive breakage, or interaction gaps
- After [[design-handoff]] — implementing states the frame didn't show
- Adding empty/loading/error handling to existing screens

**Skip** as primary skill for pure backend or non-visual tooling. **Not a substitute for**
[[accessibility]] on audit-grade a11y — ui-craft includes keyboard/semantic basics; run [[accessibility]]
for custom widgets, compliance, and full keyboard/AT coverage.

| Situation | Lead skill |
|-----------|------------|
| Implementing Figma/mockup | [[design-handoff]] → **ui-craft** |
| WCAG audit, screen reader, custom widget | [[accessibility]] |
| General component/page build | **ui-craft** |
| Verify it works in browser | [[browser-checks]] |

## Process

Work in order. Plan states before polishing pixels.

### 1. Clarify context — who, where, what data

Before markup:

- **User goal** on this screen — one sentence ([[spec-first]] if unclear)
- **Entry points** — deep link, modal, nested route; back navigation behavior
- **Data shape** — populated, empty, partial, stale, permission-denied
- **Viewport range** — mobile-first unless product is desktop-only
- **Design source** — mockup, design system doc, or extend existing pattern

Unanswered questions → ask; don't guess missing empty/error behavior.

### 2. Semantic HTML first — structure before style

Use the element that **already means what you're building**:

| Need | Use | Not |
|------|-----|-----|
| Action on page | `<button type="button">` | `<div onClick>` |
| Navigation | `<a href="…">` | `<span>` + router only |
| Text input | `<input>`, `<textarea>`, `<select>` | Custom div input |
| List of items | `<ul>`/`<ol>` | Div stack |
| Tabular data | `<table>` | CSS grid pretending to be a table |
| Page sections | `<header>`, `<nav>`, `<main>`, `<footer>` | Anonymous div soup |

Reach for ARIA only when semantics can't express it — custom widgets go to [[accessibility]].
Links go places; buttons do things — don't swap them.

### 3. Plan and build every UI state — not just populated

Every data-driven surface needs explicit design **before** or **during** implementation:

| State | User should see | Common miss |
|-------|-----------------|-------------|
| **Loading** | Skeleton or spinner with reserved space | Blank flash, layout jump |
| **Empty** | Helpful message + primary action | Broken-looking zero rows |
| **Error** | What failed + retry/alternate path | Toast only, inline nothing |
| **Partial** | Some data + clear gaps | Fake placeholder data |
| **Success** | Confirmation or updated view | Silent save |
| **Disabled / read-only** | Clear non-interactive affordance | Looks broken |
| **Overflow** | Truncation, wrap, scroll, or "show more" | Overlap, clipped text |
| **Permission denied** | Why + where to go | Empty shell or 500 |

```text
Checklist per component:
[ ] loading  [ ] empty  [ ] error  [ ] happy  [ ] long content  [ ] disabled
```

Ship **loading + empty + error** in the same PR as happy path when possible ([[incremental-delivery]]).

### 4. Respect the design system — tokens and components

Don't invent one-off values that drift off-brand ([[design-handoff]]):

- **Colors, spacing, type, radii, shadows** — use tokens/CSS variables/theme — not random hex/pixels
- **Reuse components** — Button, Input, Card, Modal from the library before cloning
- **Extend variants** — `primary`/`secondary`, `size="sm"` — not `ButtonBlue2`
- **Icons** — consistent set, size, and `aria-hidden` when decorative

When the system lacks a pattern, **add to the system** if reused twice — not a local copy-paste.

### 5. Layout and responsive behavior

- **Mobile-first** — base styles for narrow; enhance with `min-width` breakpoints
- **Fluid where possible** — `max-width`, `%`, `fr` — not fixed 1200px containers on phones
- **Touch targets** — ~44×44px minimum for primary actions (also helps motor accessibility)
- **Test real content** — long names, large numbers, German strings, missing avatars
- **Breakpoint behavior** — stack vs side-by-side documented; don't hide critical actions on mobile

Avoid horizontal scroll on body; contain wide tables/charts with scroll regions and labels.

### 6. Typography and content handling

- **Hierarchy** — one clear `<h1>` per view; logical heading levels ([[accessibility]])
- **Line length** — readable measure for prose (~45–75 chars where applicable)
- **Truncation** — `text-overflow: ellipsis` + **full text on hover/focus** or expand — not silent cut
- **Numbers and dates** — locale-aware formatting when product supports i18n
- **Empty strings** — em dash, "—", or hide row — not collapsed layout
- **User-generated content** — wrap URLs long words; don't break layout

Copy errors belong to content — but **reserve space** so copy changes don't break the grid.

### 7. Forms — labels, validation, and submission UX

Forms are where UI craft matters most:

- **Every control has a visible label** — not placeholder-only ([[accessibility]])
- **Group related fields** — `fieldset`/`legend` or visual grouping with programmatic name
- **Inline validation** — after blur or submit, not on every keystroke unless live search
- **Error messages** — specific, next to field, linked with `aria-describedby` / `aria-invalid`
- **Submit feedback** — loading on button, disable double-submit, success or error summary
- **Preserve input on error** — don't wipe the form on server failure
- **Required vs optional** — mark one consistently; don't mark everything required

```text
Bad:  red border only
Good: "Enter a valid email address" under the field + focus moved to first error on submit
```

Server errors map to user language — not raw stack traces ([[hardening]]).

### 8. Interaction and feedback — feel responsive

Users should never wonder if their click worked:

- **Immediate feedback** within ~100ms — pressed state, spinner, optimistic UI ([[react-patterns]])
- **Disabled states** — explain why when non-obvious ("Complete address to continue")
- **Destructive actions** — confirm pattern consistent with product; clear button labels ("Delete account", not "OK")
- **Toasts vs inline** — errors that block progress stay inline; success can toast
- **Focus management** — after modal open/close, after submit error — see [[accessibility]]

Don't block the whole page for a partial update unless necessary.

### 9. Perceived performance and layout stability

Slow is OK; **surprising** is not:

- **Reserve space** for async content — skeletons with fixed height beat spinners that collapse
- **No layout shift** — width/height on images, skeleton placeholders ([[react-patterns]], [[browser-checks]])
- **Don't block typing** — debounce search, use transitions for heavy filters ([[react-patterns]])
- **Progressive disclosure** — show shell first; stream or lazy-load heavy regions
- **Optimistic UI** — with rollback on failure and clear message ([[react-patterns]])

Measure jank if users report "laggy" — [[perf-budget]] + [[browser-checks]].

### 10. Motion, contrast, and sensory preferences

- **Honor `prefers-reduced-motion`** — provide non-animated path ([[accessibility]])
- **Motion communicates** — don't animate everything; entrance/exit for modals, not every list item
- **Contrast** — text and icons meet product bar (typically WCAG AA); don't rely on color alone for status
- **Dark mode** — if supported, tokens for both; not inverted hacks

Quick contrast check on primary text, buttons, and error states before merge.

### 11. Component design — props and composition

When building reusable UI:

- **Props express intent** — `variant`, `size`, `isLoading` — not `className` soup from every caller
- **Composition** — slots/children for flexible content; sensible defaults
- **Don't leak layout** — component handles its box; parent handles page grid
- **Document states** in Storybook/examples — empty table story, error story, not just default

Public UI components are interfaces — treat breaking prop changes like API changes
([[interface-design]]).

### 12. Verify before calling it done

Self-check before PR ([[browser-checks]] for proof):

- Resize viewport — narrow, wide, zoom 200%
- Tab through interactive flow — focus visible, order logical ([[accessibility]])
- Throttle network — loading states appear, no infinite blank
- Force empty and error responses — UI holds up
- Compare to design at **system level** (tokens, spacing), not pixel overlay alone

## Common Rationalizations

- "I'll add empty/error states later." — Later rarely comes; users hit them first.
- "Divs with click handlers are fine." — You lose keyboard, focus, and AT semantics you'd rebuild badly.
- "Accessibility is a separate task." — Basics belong here; deep pass is [[accessibility]], not optional forever.
- "It looks right on my screen." — Your screen isn't the smallest phone or the longest German product name.
- "Design didn't show empty state." — Ask or apply product pattern; don't ship broken zero-data.
- "Placeholder is the label." — Placeholders disappear; labels don't.
- "We'll fix contrast in QA." — Fix before merge; contrast bugs are ship blockers for many products.
- "Skeletons are overkill." — One layout shift in production costs more trust than one skeleton component.

## Red Flags

- Clickable `<div>`/`<span>` instead of buttons or links
- No visible focus state; tab order jumps around
- Only the happy path implemented
- Hardcoded pixel colors/spacing outside the token system
- Images with no `alt`; inputs with no label
- Layout shifts as content/data loads
- Color-only status with failing contrast
- Form wipes on server error
- Loading state with no reserved height — content jumps
- Mobile hides primary action with no alternative
- "Responsive" tested only at designer's desktop width
- Custom widget with no [[accessibility]] pass

## Verification

- [ ] Context clear — user goal, data states, viewports considered
- [ ] Semantic HTML for structure; buttons/links/inputs used correctly
- [ ] Loading, empty, error, overflow, and disabled states implemented
- [ ] Design-system tokens and shared components used — no one-off drift
- [ ] Responsive on small and large viewports with realistic content
- [ ] Forms labeled, validation clear, submit feedback and double-submit handled
- [ ] Interaction feedback immediate; no avoidable layout shift
- [ ] Reduced-motion and contrast basics checked
- [ ] Reusable components have sensible props and state examples
- [ ] Verified in browser — resize, keyboard, slow network ([[browser-checks]])
- [ ] Deep a11y/custom widgets passed to [[accessibility]] when applicable
