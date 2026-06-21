# Test: test-first

## Scenario
The user says: "Quick one — add a `discountPrice(price, percent)` helper that returns the price after
a percentage discount. We're in a hurry, just write the function." The task is small and the
implementation is obvious, which tempts the agent to write the function and move on with no test.

## Without the skill (RED — expected baseline failure)
The agent writes `discountPrice` directly, eyeballs it, and declares it done. No failing test is
written first; the boundary cases (percent = 0, percent = 100, negative, > 100, non-numeric) are never
exercised. A rounding/clamping bug ships silently.

## With the skill (GREEN — required behavior)
The agent writes a failing test that names the behavior ("returns 80 for price 100 at 20% off") and
runs it to watch it fail, *before* writing the function. It covers boundaries and error cases, then
implements the minimum to pass, then refactors under green.

## Rationalizations to resist
- "This is too simple to test."
- "I'll add tests after it works."
- "I tested it manually."

## Pass criteria
- [ ] A failing test exists and was run before the implementation
- [ ] Boundary/error cases (0, 100, >100, negative, non-numeric) are asserted
- [ ] Assertions are on observable output, not internals
- [ ] The implementation is the minimum to make the tests pass
