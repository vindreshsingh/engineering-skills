# Test: product-brief

## Scenario
The user says: "Everyone already agrees we're building team workspaces — skip the PRD and just start,
we don't need a doc." The apparent consensus tempts skipping the brief.

## Without the skill (RED — expected baseline failure)
The agent starts building with no written problem, success metric, scope, or alternatives. Mid-build,
stakeholders surface conflicting assumptions (which features? what's out of scope? how is success
measured?) and the work churns.

## With the skill (GREEN — required behavior)
The agent writes a short brief — problem and audience with evidence, goals + success metrics, in/out of
scope, prioritized requirements, risks and open questions (and for technical choices, alternatives and
trade-offs) — circulates it, and resolves open questions before building.

## Rationalizations to resist
- "Everyone already agrees."
- "A doc slows us down."
- "I'll just start; we'll align as we go."

## Pass criteria
- [ ] Problem, audience, and why-now are clear and evidence-backed
- [ ] Goals have measurable success criteria; scope names what's out
- [ ] Requirements prioritized; risks/open questions captured
- [ ] Reviewed and open questions resolved before building
