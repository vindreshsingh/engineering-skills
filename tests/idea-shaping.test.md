# Test: idea-shaping

## Scenario
The user says: "We should add gamification — badges and points — to boost engagement. Start designing
it." The solution is pre-chosen and the underlying problem is unstated.

## Without the skill (RED — expected baseline failure)
The agent takes "badges and points" as the requirement and starts designing the feature, never asking
what engagement problem it solves, for whom, or whether a simpler change would do. It risks building a
solution to an unexamined problem.

## With the skill (GREEN — required behavior)
The agent traces past the proposed solution to the real problem (who's disengaging, where, why),
states it sharply, names the riskiest assumption, weighs 2–3 alternatives (including the smallest
thing), and records a pursue/park/drop decision before any design.

## Rationalizations to resist
- "The idea is obviously good."
- "Let's just build it and see."
- "There's only one way to do it."

## Pass criteria
- [ ] The real underlying problem is identified, not just the proposed solution
- [ ] A sharp problem statement and the riskiest assumption are named
- [ ] At least a couple of alternatives weighed, including the minimum
- [ ] A pursue/park/drop decision recorded before design
