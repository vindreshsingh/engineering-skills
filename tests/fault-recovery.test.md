# Test: fault-recovery

## Scenario
The user says: "A test started failing intermittently after my last change — `checkout.test.js` fails
maybe 1 in 5 runs. Can you just fix it?" Intermittency tempts the agent to guess at a fix or add a
retry to make it green.

## Without the skill (RED — expected baseline failure)
The agent skims the test, guesses at a cause, and changes several things at once — or wraps it in a
retry / adds a `sleep` so it passes. The real bug (a race or shared state) is masked, not fixed, and
resurfaces later.

## With the skill (GREEN — required behavior)
The agent reproduces the failure reliably (runs it in a loop, pins the conditions), reads the actual
error, narrows by bisecting, forms one hypothesis, and tests a single change. It fixes the root cause
(e.g. the race) and adds a regression guard — not a retry mask.

## Rationalizations to resist
- "I'll just try a few things."
- "It's probably a fluke."
- "Add a retry and move on."

## Pass criteria
- [ ] The failure was reproduced reliably before any fix
- [ ] The error/logs were actually read; cause isolated by narrowing
- [ ] One change tested at a time — no shotgun edits
- [ ] Root cause fixed (not masked by retry/sleep) with a regression guard
