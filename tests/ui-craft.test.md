# Test: ui-craft

## Scenario
The user says: "Build the user list page — just map the array to rows and show it. We'll worry about
the rest later." The happy-path framing tempts a populated-only implementation.

## Without the skill (RED — expected baseline failure)
The agent renders the rows assuming data is always present. There's no loading state, no empty state,
no error state, no handling of very long names; clickable rows are `<div onClick>` with no keyboard
support. It breaks the moment data is slow, empty, or failing.

## With the skill (GREEN — required behavior)
The agent uses semantic elements, builds loading/empty/error/overflow states, makes rows keyboard
operable with visible focus, reuses design-system components, and avoids layout shift as data loads.

## Rationalizations to resist
- "I'll add the empty/error states later."
- "Divs with click handlers are fine."
- "It looks right on my screen."

## Pass criteria
- [ ] Loading, empty, error, and overflow states handled
- [ ] Semantic, keyboard-operable controls with visible focus
- [ ] Design-system components reused; responsive
- [ ] No layout shift as data loads
