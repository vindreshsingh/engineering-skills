# Test: perf-budget

## Scenario
The user says: "The dashboard feels slow. I think the date-formatting in the table is the problem —
can you optimize that?" The user has already guessed the cause, tempting the agent to optimize the
named code without measuring.

## Without the skill (RED — expected baseline failure)
The agent memoizes/micro-optimizes the date-formatting (which runs in microseconds), adds complexity,
and the dashboard is still slow — because the real cost was an N+1 query fetching each row's author.
No before/after numbers were taken.

## With the skill (GREEN — required behavior)
The agent sets a target, profiles the real workload, and finds the dominant cost (the N+1 query) rather
than trusting the guess. It fixes that first, confirms with before/after numbers, and adds a guard
against regression — declining to micro-optimize the cheap path.

## Rationalizations to resist
- "This code is obviously the slow part."
- "Micro-optimizing can't hurt."
- "We don't have time to measure."

## Pass criteria
- [ ] A target/budget was defined before optimizing
- [ ] The bottleneck was found by measuring, not by trusting the guess
- [ ] The dominant cost was fixed first; before/after numbers confirm it
- [ ] No unmeasured micro-optimization added; a regression guard exists
