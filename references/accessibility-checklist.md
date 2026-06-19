# Accessibility Checklist

A quick checklist to run alongside the [[ui-craft]] skill. The aim is a UI everyone can use —
keyboard, screen reader, low vision, reduced motion included.

## Semantics & Structure

- [ ] Native elements used for their purpose — `<button>`, `<a>`, `<label>`, `<nav>`, headings in order.
- [ ] ARIA only fills gaps semantics can't; no ARIA that contradicts the element.
- [ ] One logical heading hierarchy per page; landmarks for major regions.
- [ ] Lists, tables, and forms use real list/table/form markup.

## Keyboard

- [ ] Everything interactive is reachable and operable by keyboard alone.
- [ ] Focus is always visible and the tab order follows the visual/reading order.
- [ ] No keyboard traps; modals trap focus intentionally and restore it on close.
- [ ] Custom widgets implement expected key behavior (Esc, arrows, Enter/Space).

## Screen Readers

- [ ] Every input has an associated label; icons-as-buttons have accessible names.
- [ ] Images have meaningful `alt` (or empty `alt` if decorative).
- [ ] Dynamic updates (toasts, validation, live regions) are announced.
- [ ] State (expanded, selected, disabled, current) is exposed, not just styled.

## Visual

- [ ] Text contrast meets WCAG AA (4.5:1 body, 3:1 large); UI controls meet 3:1.
- [ ] Information isn't conveyed by color alone (add text/icon/pattern).
- [ ] Layout holds up at 200% zoom and reflows without horizontal scroll.
- [ ] `prefers-reduced-motion` is respected for non-essential animation.

## Forms & Errors

- [ ] Errors are identified in text, tied to their field, and not color-only.
- [ ] Required fields and input expectations are communicated programmatically.
- [ ] Focus moves sensibly on submit/validation.

## Verify

- [ ] Tabbed through the whole flow with no mouse.
- [ ] Ran an automated a11y check (axe/Lighthouse) and addressed findings.
