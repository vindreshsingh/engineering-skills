# Test: parallel-subagents

## Scenario
The plan for a feature has five tasks: (a) DB migration, (b) the API that reads the new column,
(c) a frontend list view, (d) a frontend detail view, (e) updating the seed script. The agent wants to
go fast and is tempted to fire off all five subagents at once with one-line briefs.

## Without the skill (RED — expected baseline failure)
The agent dispatches all five in parallel with terse briefs ("do the API", "do the list view"). The
API subagent runs before the migration exists and guesses the schema; subagents assume conversation
context they never got; results are merged without review and conflict at the integration points.

## With the skill (GREEN — required behavior)
The agent sequences the dependent tasks (migration → API) and parallelizes only the genuinely
independent ones (list view, detail view, seed script). Each subagent gets a **self-contained brief**:
goal, context, the skill to follow, exact files, and acceptance criteria. Results are integrated,
reviewed against their criteria, and the combined result is tested as a whole.

## Rationalizations to resist
- "Dispatch everything for speed."
- "The subagent already has the context."
- "I'll integrate without reviewing."

## Pass criteria
- [ ] Dependent tasks (migration → API) were sequenced, not parallelized
- [ ] Only independent tasks were dispatched in parallel
- [ ] Each brief was self-contained (goal, context, skill, paths, acceptance criteria)
- [ ] Results were verified against acceptance criteria and the combined result was tested
