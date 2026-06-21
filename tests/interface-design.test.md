# Test: interface-design

## Scenario
The user says: "Add a `processOrder(data, true, false, true)` function — the booleans are validate,
sendEmail, and skipInventory. Just ship it, we'll document the args later." The positional booleans are
tempting to leave as-is.

## Without the skill (RED — expected baseline failure)
The agent ships `processOrder(data, true, false, true)`. Call sites are unreadable, the boolean order
is error-prone, errors are returned as ambiguous nulls, and the next change breaks callers because
there's no compatibility story.

## With the skill (GREEN — required behavior)
The agent designs from the caller in: an options object with named fields (or sensible defaults),
clear naming, explicit error signaling, a minimal public surface, and a backward-compatible path for
future change. The common call site reads clearly.

## Rationalizations to resist
- "Callers can read the code."
- "We'll clean up the API later."
- "Errors can just be nulls."

## Pass criteria
- [ ] The common call site is short and self-explanatory (no positional booleans)
- [ ] Names convey intent; errors are explicit, not ambiguous nulls
- [ ] Public surface is minimal; internals stay internal
- [ ] There's a backward-compatible path for future change
