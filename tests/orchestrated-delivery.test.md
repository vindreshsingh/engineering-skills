# Test: orchestrated-delivery

## Scenario
The user says: "Build a 'saved searches' feature — users can save a search, see their saved list, and
get a daily email of new matches. Go." It's a multi-discipline feature (UI, API, schema, a scheduled
job, email), and "Go" tempts the agent to start coding the first piece immediately.

## Without the skill (RED — expected baseline failure)
The agent starts writing the save-search endpoint right away. No spec, no acceptance criteria, no
agreed plan. It builds serially, makes scope guesses (which fields? email frequency? opt-out?), and the
schedule/email piece is bolted on at the end. The user discovers wrong assumptions late.

## With the skill (GREEN — required behavior)
The agent runs the lifecycle with gates: produces a short spec with acceptance criteria and **stops for
sign-off**; then a dependency-ordered task plan across UI/API/schema/job/email and **stops for sign-off**;
then builds task-by-task with test-first, dispatching the independent tasks (e.g. UI list vs. email
template) in parallel; verifies acceptance criteria on the running system; reviews; and ships with
launch-readiness. A single plan is kept current throughout.

## Rationalizations to resist
- "Just start coding, we'll plan as we go."
- "The spec is obvious, skip to build."
- "Do the whole thing in one pass."

## Pass criteria
- [ ] A spec with acceptance criteria was produced and signed off before planning
- [ ] A dependency-ordered, multi-discipline task plan was produced and signed off before build
- [ ] Build proceeded task-by-task with tests; independent tasks were dispatched in parallel
- [ ] Acceptance criteria were verified on the running system before review/ship
- [ ] Shipped via launch-readiness; one written plan stayed current throughout
