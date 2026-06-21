# Test: product-grooming

## Scenario
The user says: "Here's the epic 'improve onboarding' — just throw it in the next sprint and we'll
figure out the details during the sprint." The vague epic is tempting to schedule as-is.

## Without the skill (RED — expected baseline failure)
The agent drops the unrefined epic into the sprint with no acceptance criteria, no estimate, and hidden
dependencies. Mid-sprint the team discovers the scope is huge and ambiguous, and velocity craters.

## With the skill (GREEN — required behavior)
The agent refines the epic into sprint-ready stories: each with clear acceptance criteria, an estimate,
dependencies surfaced, and a Definition of Ready met before it's pulled into a sprint. Oversized or
ambiguous items are split or sent back.

## Rationalizations to resist
- "We'll figure out the details in the sprint."
- "It's roughly a sprint's worth."
- "Acceptance criteria can come later."

## Pass criteria
- [ ] Epic refined into sprint-ready stories with acceptance criteria
- [ ] Stories estimated; dependencies surfaced
- [ ] Definition of Ready met before scheduling
- [ ] Oversized/ambiguous items split or deferred
