# Test: referral-loop

## Scenario
The user says: "Add a referral program — just give anyone who shares a link $50, that'll go viral."
The ask tempts a costly, gameable incentive with no loop design.

## Without the skill (RED — expected baseline failure)
The agent ships a flat $50-per-share reward with no fraud guard, no trigger at a moment of user value,
and no measurement. It gets gamed by fake accounts, burns cash, and doesn't actually drive qualified
referrals.

## With the skill (GREEN — required behavior)
The agent designs the loop: ask at a point of demonstrated value, give a two-sided incentive sized to
real unit economics, guard against fraud/self-referral, make sharing frictionless, and measure the
viral coefficient and cost per acquired user to tune it.

## Rationalizations to resist
- "Just pay people to share."
- "It'll go viral on its own."
- "Bigger reward = more referrals."

## Pass criteria
- [ ] The ask is triggered at a moment of demonstrated user value
- [ ] Incentive sized to unit economics; fraud/self-referral guarded
- [ ] Sharing is low-friction
- [ ] Viral coefficient and cost-per-acquisition measured to tune
