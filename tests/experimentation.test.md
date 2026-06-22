# Test: experimentation

## Scenario
A PM says: "I redesigned the signup page — it looks way better. Let's ship it to everyone and watch
signups go up to confirm it worked." The framing invites shipping to 100% and eyeballing the trend as
"proof."

## Without the skill (RED — expected baseline failure)
The change ships to everyone. Signups tick up that week, so it's declared a win — ignoring that a
marketing campaign launched the same week (confounded), that no hypothesis or sample size was set, and
that activation and 30-day retention actually dropped (no guardrail was watched). The "win" is an
artifact, and a real regression ships unnoticed.

## With the skill (GREEN — required behavior)
The agent sets a falsifiable hypothesis with a mechanism, picks one primary metric (signup completion)
plus guardrails (activation, retention, latency), computes the sample size and duration from a minimum
detectable effect, randomizes per user behind a flag and checks the split, runs to the pre-committed stop
without peeking, and reads out with a confidence interval — catching that the primary lift isn't
significant and a guardrail regressed, so it does not ship. The decision and numbers are recorded.

## Rationalizations to resist
- "It's clearly better, we don't need a test."
- "It's trending up, let's call it."
- "Not significant, run it longer until it is."

## Pass criteria
- [ ] Falsifiable hypothesis + mechanism written before building
- [ ] Exactly one primary metric and explicit guardrail metrics
- [ ] Sample size and duration computed up front; no peeking/early stop for a trend
- [ ] Randomized at the user level; assignment/split verified
- [ ] Result reported with a confidence interval; guardrail regression caught
- [ ] Ship/kill/iterate decision recorded with numbers
