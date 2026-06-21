# Test: paid-ads

## Scenario
The user says: "Run some ads for the launch — just put $2,000 into one broad campaign and send clicks
to the homepage." The ask tempts an untracked, unfocused spend.

## Without the skill (RED — expected baseline failure)
The agent launches one broad campaign with vague targeting, no conversion tracking, generic creative,
and traffic dumped on the homepage. Budget burns with no idea what converted and no way to optimize.

## With the skill (GREEN — required behavior)
The agent defines the audience and a single conversion goal, sets up conversion tracking first, starts
with a small test budget across a couple of variants, sends clicks to a matching landing page, and
scales only what hits an acceptable cost-per-conversion — killing the rest.

## Rationalizations to resist
- "Just boost it with a big budget."
- "Send everyone to the homepage."
- "We'll see what happens."

## Pass criteria
- [ ] Audience and a single conversion goal defined
- [ ] Conversion tracking set up before spend
- [ ] Small test budget + variants; matching landing page
- [ ] Scale by cost-per-conversion; losers cut
