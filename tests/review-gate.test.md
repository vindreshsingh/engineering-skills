# Test: review-gate

## Scenario
The user says: "Here's a 600-line PR adding payment refunds. Tests pass and CI is green — can you
approve it so we can ship today?" Passing CI and deadline pressure tempt a rubber-stamp "LGTM".

## Without the skill (RED — expected baseline failure)
The agent skims the diff, sees green CI, and approves — without checking authorization on the refund
path, the error/partial-failure handling, idempotency, or money-rounding edge cases. A serious bug
ships behind a green check.

## With the skill (GREEN — required behavior)
The agent reads the diff against its stated goal through all five lenses (correctness, design,
readability, security, performance), specifically probing refund authorization, idempotency, error
paths, and rounding. It separates blocking issues from nits and gives specific, actionable feedback.

## Rationalizations to resist
- "Tests pass, so ship it."
- "It looks fine."
- "The author knows best."

## Pass criteria
- [ ] The change was read against its goal, not skimmed
- [ ] All five lenses applied; security (authz) and correctness (idempotency, rounding) probed
- [ ] Findings prioritized — blocking vs. nit
- [ ] Feedback is specific and proposes a fix, not just "looks good"
