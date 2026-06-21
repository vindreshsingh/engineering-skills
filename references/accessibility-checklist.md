# Accessibility Checklist

Quick reference to run alongside the [[accessibility]] skill. Target WCAG 2.2 Level AA.

## Page foundation

- [ ] One `<h1>` per view; heading levels in order (no skipped levels).
- [ ] Landmarks present: `<header>`, `<nav>`, `<main>`, `<footer>` as appropriate.
- [ ] Skip link to main content is first focusable element.
- [ ] `lang` set on `<html>` (and on inline foreign-language passages).
- [ ] Real list/table/form markup — not div-only structure.

## Semantics & ARIA

- [ ] Native elements used for purpose — `<button>`, `<a>`, `<label>`, `<nav>`.
- [ ] ARIA only fills gaps; no ARIA contradicting the element's role.
- [ ] Custom widgets follow WAI-ARIA Authoring Practices (keyboard + roles + states).
- [ ] No `aria-hidden` on interactive or focusable content.

## Keyboard

- [ ] Everything interactive reachable and operable by keyboard alone.
- [ ] Focus always visible (3:1 contrast against adjacent colors).
- [ ] Tab order follows reading order; no positive `tabindex`.
- [ ] Modals trap focus, close on Esc, restore focus to trigger.
- [ ] Custom widgets implement expected keys (arrows, Esc, Enter/Space).
- [ ] SPA route changes move focus to main heading or landmark.

## Names, labels & state

- [ ] Every input has a visible, associated label (not placeholder-only).
- [ ] Icon buttons have accessible names; decorative icons are `aria-hidden`.
- [ ] Images have meaningful `alt` or `alt=""` if decorative.
- [ ] State exposed: expanded, selected, checked, current, disabled, invalid.
- [ ] Help text and errors linked via `aria-describedby`.

## Dynamic content

- [ ] Toasts/status use `role="status"` or polite live region.
- [ ] Errors/alerts use `role="alert"` or assertive live region.
- [ ] Loading regions use `aria-busy`; completion announced when appropriate.
- [ ] Infinite scroll has keyboard-accessible alternative or announcement.

## Visual & motor

- [ ] Text contrast ≥ 4.5:1 (normal) / 3:1 (large text, UI components).
- [ ] Information not conveyed by color alone.
- [ ] Layout holds at 200% zoom without horizontal scroll.
- [ ] Touch targets ≥ 24×24 CSS px (44×44 preferred for primary actions).
- [ ] No hover-only functionality.
- [ ] `prefers-reduced-motion` respected; no disabled zoom.

## Forms

- [ ] Required fields marked in text and exposed programmatically.
- [ ] Appropriate `autocomplete` attributes.
- [ ] Errors in text, tied to fields via `aria-describedby`, `aria-invalid` set.
- [ ] Submit failure focuses error summary or first invalid field.
- [ ] User input preserved on validation failure.

## High-risk patterns

- [ ] Modals: labelled, focus trap, Esc, focus restore.
- [ ] Tabs/combobox/menus: APG keyboard model implemented.
- [ ] Data tables: headers scoped, caption or label, sort state exposed.
- [ ] Carousels: pause control; no auto-advance without reduced-motion fallback.
- [ ] Drag-and-drop has keyboard alternative.

## Verify

- [ ] Automated check (axe / Lighthouse / eslint-jsx-a11y) — errors fixed.
- [ ] Full keyboard-only pass through the flow.
- [ ] Screen reader spot-check (VoiceOver or NVDA): names, roles, states, announcements.
- [ ] 200% zoom + reduced motion checked.
- [ ] Known gaps documented if deferred.
