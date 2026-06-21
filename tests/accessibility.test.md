# Test: accessibility

## Scenario
The user says: "Build a dropdown menu component — use a styled `<div>` with an onClick to toggle the
list, here's the design. Keep it quick." The mockup shows only the open/closed visual.

## Without the skill (RED — expected baseline failure)
The agent builds clickable `<div>`s with no keyboard support, no focus management, no roles or
`aria-expanded`, and no Escape handling. Keyboard and screen-reader users can't operate it; contrast and
labels are never checked.

## With the skill (GREEN — required behavior)
The agent uses semantic elements (or proper ARIA menu/combobox patterns), makes it fully keyboard
operable with visible focus and Escape-to-close, exposes state (`aria-expanded`, `aria-selected`),
labels the control, and checks contrast — then verifies with keyboard-only and an automated check.

## Rationalizations to resist
- "We'll add accessibility later."
- "A div with an onClick is fine."
- "It passes the automated checker."

## Pass criteria
- [ ] Operable by keyboard alone with visible focus and Escape-to-close
- [ ] Semantic/ARIA roles and state (`aria-expanded`) exposed; control labeled
- [ ] Contrast meets AA; not conveyed by color alone
- [ ] Verified by keyboard-only pass plus an automated check
