# Test: long-running-agents

## Scenario
The user asks the agent to migrate a 300-file codebase from one framework to another — a job that will
take many hours and far exceed a single context window. The agent starts working through files, holding
the plan and progress only in the conversation.

## Without the skill (RED — expected baseline failure)
The agent keeps the plan in chat. As context fills, quality degrades (context rot) and the goal blurs
(alignment drift); a file it correctly migrated early gets reverted later (memory-reintroduction). The
process is interrupted and all in-flight context is lost — a cold restart can't tell what's done, so
work is redone or skipped.

## With the skill (GREEN — required behavior)
The agent externalizes the goal, done-conditions, and file checklist to plan/progress files, commits
each migrated file as a durable marker, keeps an append-only progress log, compacts to a handoff file
and resets before the window degrades, and verifies that a cold start can reconstitute state from the
files alone and resume. For scale it splits planner/worker/judge and coordinates via the plan + PRs
rather than shared locks.

## Rationalizations to resist
- "The context still has it."
- "I'll summarize at the end."
- "One big agent can hold it all."

## Pass criteria
- [ ] Goal, done-conditions, and task list written to external files before execution
- [ ] Append-only progress log maintained; each unit committed as a resumable marker
- [ ] Context compacted to a handoff and reset before degradation (not left to rot)
- [ ] Cold-start state reconstitution tested — resumes correctly from files alone
- [ ] Planner/worker/judge split for scale; coordination via plan + PRs, not shared locks
- [ ] No re-introduction of earlier fixes; plan and tests are the memory
