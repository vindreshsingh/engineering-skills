# Test: ux-design

## Scenario
The user says: "Add a bulk-delete to the items table — just put a Delete button that removes the
selected rows immediately." The terse ask tempts a destructive action with no flow design.

## Without the skill (RED — expected baseline failure)
The agent adds an immediate bulk-delete with no confirmation, no undo, no feedback on what happened,
and no empty/selection states considered. Users delete dozens of rows by accident with no recovery.

## With the skill (GREEN — required behavior)
The agent designs the flow: clear selection affordance and count, a confirmation (or undo) for a
destructive irreversible action, feedback on success/failure, and the empty and partial-failure states.
It maps the user's actual goal, not just the button.

## Rationalizations to resist
- "Just add the button."
- "Users know what delete does."
- "Edge states aren't UX."

## Pass criteria
- [ ] The user flow and goal were designed, not just a control added
- [ ] Destructive action has confirmation or undo, with clear feedback
- [ ] Selection, empty, and partial-failure states were considered
- [ ] Interaction spec is clear enough to implement against
