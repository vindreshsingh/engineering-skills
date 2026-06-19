---
name: accessibility
description: Builds UI that everyone can use — keyboard, screen reader, low vision, reduced motion. Use when creating or changing any user-facing interface, or reviewing UI for a11y compliance.
---

# Accessibility

Accessible UI works for people using a keyboard, a screen reader, magnification, or reduced motion —
not just a mouse and perfect vision. It's a requirement, not a polish step, and it's far cheaper built
in than retrofitted. This is the process; the [accessibility checklist](../../references/accessibility-checklist.md)
is the quick reference to run alongside it.

## When to Use

- Building or changing any component, page, form, or interactive widget
- Reviewing front-end work for accessibility before merge
- Fixing reported a11y issues or preparing for an audit
- Works hand in hand with [[ui-craft]] and [[design-handoff]]

## Process

1. **Start with semantic HTML.** Use the element that means what you intend — `<button>`, `<a>`,
   `<label>`, `<nav>`, ordered headings. Native semantics give keyboard and assistive-tech behavior
   for free; reach for ARIA only to fill genuine gaps, never to contradict the element.
2. **Make everything keyboard-operable.** Every interactive control is reachable and usable with the
   keyboard alone, focus is always visible, and tab order follows reading order. No keyboard traps.
3. **Name everything for assistive tech.** Inputs have associated labels, icon buttons have accessible
   names, images have meaningful `alt` (or empty `alt` if decorative). Expose state (expanded,
   selected, disabled, current), don't just style it.
4. **Announce dynamic changes.** Toasts, validation messages, and async updates use live regions or
   focus management so screen-reader users learn what changed.
5. **Meet visual needs.** Text contrast at WCAG AA (4.5:1 body, 3:1 large/controls); never convey
   meaning by color alone; layout survives 200% zoom; honor `prefers-reduced-motion`.
6. **Handle forms accessibly.** Errors are in text, tied to their field, not color-only; required
   fields and expectations are communicated programmatically; focus moves sensibly on submit.
7. **Verify, don't assume.** Tab through the whole flow with no mouse, run an automated checker
   (axe/Lighthouse), and address findings.

## Common Rationalizations

- "We'll add accessibility later." — Retrofitting costs far more and usually never happens.
- "A div with an onClick is fine." — It loses keyboard, focus, and screen-reader semantics you'd rebuild badly.
- "Most of our users don't need it." — You can't see who does, and in many places it's also a legal requirement.
- "It passes the automated checker." — Automated tools catch ~part of issues; keyboard and SR testing catch the rest.

## Red Flags

- Clickable `<div>`/`<span>` instead of buttons or links
- No visible focus state; tab order jumps around; keyboard traps
- Inputs without labels, images without `alt`, icon buttons with no name
- Status conveyed by color alone; contrast below AA
- Dynamic updates that screen readers never announce
- Motion with no `prefers-reduced-motion` fallback

## Verification

- [ ] Semantic elements used; ARIA only to fill real gaps
- [ ] Fully keyboard operable with visible, logical focus and no traps
- [ ] Labels, alt text, accessible names, and exposed state present
- [ ] Dynamic changes are announced to assistive tech
- [ ] Contrast meets AA; not color-only; zoom and reduced-motion respected
- [ ] Forms: text errors tied to fields, sensible focus handling
- [ ] Verified by keyboard-only pass + automated checker
