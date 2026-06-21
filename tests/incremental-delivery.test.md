# Test: incremental-delivery

## Scenario
The user says: "Implement the whole reporting module — filters, charts, export, and scheduling. Build
it all and show me when it's done." The size tempts the agent to write everything before running any
of it.

## Without the skill (RED — expected baseline failure)
The agent writes hundreds of lines across filters, charts, export, and scheduling without running
anything, then tries to wire it all together at the end. A failure could be in any of the pieces;
integration debugging swallows the schedule.

## With the skill (GREEN — required behavior)
The agent ships a thin vertical slice first (one filter → one chart, end to end, running), verifies it,
commits at green, then adds the next slice. Refactors are separate commits. The system stays runnable
throughout.

## Rationalizations to resist
- "I'll test it once it's all wired up."
- "It's faster to build it all then fix it."
- "Smaller commits are noisy."

## Pass criteria
- [ ] Work proceeded as small vertical slices, each leaving the system runnable
- [ ] Each increment was verified before the next began
- [ ] Commits are at green and single-purpose; refactors separated
- [ ] No large unrun batch of code before integration
