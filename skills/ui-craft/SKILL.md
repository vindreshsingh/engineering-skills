---
name: ui-craft
description: Builds accessible, responsive, polished front-end UI. Use when creating or changing components, layouts, forms, or any user-facing interface, and when reviewing UI for quality and a11y.
---

# UI Craft

Good UI is correct, accessible, responsive, and resilient under real conditions — empty, loading,
error, and overflow states included. The happy-path mockup is the easy 60%; the rest is the craft.

## When to Use

- Building or changing any user-facing component, page, form, or layout
- Reviewing front-end work for accessibility and quality
- Turning a design into code (pair with [[design-handoff]])
- Fixing visual bugs, responsive breakage, or interaction issues

## Process

1. **Use semantic HTML first.** A `<button>` is a button; reach for ARIA only to fill gaps semantics
   can't. Native elements get keyboard and screen-reader behavior for free.
2. **Build every state**, not just the populated one: loading, empty, error, partial, and long-content
   overflow. Decide what each looks like before you start.
3. **Make it keyboard- and screen-reader-usable.** Focus is visible and logically ordered, controls are
   labeled, interactive targets are reachable without a mouse.
4. **Be responsive by default.** Test small and large viewports; avoid fixed widths that break on
   real content.
5. **Respect the design system.** Use existing tokens and components instead of one-off values that
   drift from the rest of the product.
6. **Mind perceived performance.** Avoid layout shift, show feedback within a frame or two of input,
   and don't block interaction on slow data.
7. **Check contrast and reduced-motion**, and verify with a quick a11y pass.

## Common Rationalizations

- "I'll add the empty/error states later." — Later rarely comes, and users hit them first.
- "Divs with click handlers are fine." — They lose keyboard, focus, and AT semantics you'd rebuild badly.
- "Accessibility is a separate task." — Retrofitting a11y costs far more than building it in.
- "It looks right on my screen." — Your screen isn't the smallest phone or the longest string.

## Red Flags

- Clickable `<div>`/`<span>` instead of buttons or links
- No visible focus state; tab order jumps around
- Only the happy path is implemented
- Hardcoded pixel widths, images with no `alt`, inputs with no label
- Layout shifts as content/data loads
- Color-only status with failing contrast

## Verification

- [ ] Semantic elements used; ARIA only where needed
- [ ] Loading, empty, error, and overflow states all handled
- [ ] Fully keyboard navigable with visible, logical focus
- [ ] Responsive across small and large viewports
- [ ] Design-system tokens/components reused, not reinvented
- [ ] Contrast passes; no avoidable layout shift; labels and alt text present
