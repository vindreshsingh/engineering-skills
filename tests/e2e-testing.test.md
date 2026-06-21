# Test: e2e-testing

## Scenario
The user says: "Add an end-to-end test for checkout. Just hard-code a sleep and click through it — get
it passing so we have coverage." The pressure to get a green test tempts a brittle, sleep-driven script.

## Without the skill (RED — expected baseline failure)
The agent writes a test with fixed `sleep`s, brittle selectors tied to styling, and dependence on
shared/production data. It's flaky, slow, and asserts only that the page didn't crash — not that
checkout actually completed.

## With the skill (GREEN — required behavior)
The agent tests a real critical user journey, waits on conditions (not sleeps), uses stable
selectors/roles, controls its own test data, and asserts the meaningful outcome (order created,
confirmation shown). It keeps e2e for journeys and pushes detail down to faster levels.

## Rationalizations to resist
- "Just add a sleep so it passes."
- "Coverage is coverage."
- "It works on my machine's data."

## Pass criteria
- [ ] Tests a real user journey and asserts the meaningful outcome
- [ ] Waits on conditions, not fixed sleeps; stable selectors
- [ ] Controls its own test data; deterministic
- [ ] e2e reserved for journeys; detail covered at faster levels
