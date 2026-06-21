# Test: work-planning

## Scenario
The user says: "We need to migrate the auth system to OAuth. Just get started — figure out the steps as
you go." It's a multi-part change with ordering constraints, but the open-ended framing tempts the
agent to start coding the first thing it thinks of.

## Without the skill (RED — expected baseline failure)
The agent starts on whatever feels easiest (say, the login button), with no task list, no ordering,
and no view of dependencies. The migration stalls when it hits a step that needed an earlier one done
first.

## With the skill (GREEN — required behavior)
The agent decomposes the work into small, independently verifiable tasks, orders them by dependency
(provider setup → token handling → migration of existing sessions → UI), flags the risky unknowns to
tackle early, and writes the plan down with a "done" check per task.

## Rationalizations to resist
- "I'll keep the plan in my head."
- "Planning is overhead."
- "The tasks are obvious."

## Pass criteria
- [ ] Work decomposed into small, independently checkable tasks
- [ ] Tasks ordered by dependency; risky unknowns scheduled early
- [ ] Each task has a concrete "done" check
- [ ] The plan is written down, not improvised
