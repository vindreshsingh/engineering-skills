---
name: long-running-agents
description: Keeps an agent (or a planner/worker/judge fleet) coherent across hours or days and thousands of model calls — using external plan and progress files, checkpoint-and-resume, and context compaction so the run survives context limits, crashes, and drift. Use when a task is too big for one context window or must run unattended over a long horizon.
---

# Long-Running Agents

A task that runs for hours will exceed any context window and outlive any single process. The failures
are predictable: **context rot** (quality degrades as the window fills), **alignment drift** (the goal
blurs through successive summaries), and lost work when a process dies. The fix is to stop treating the
model's context as the source of truth and move durable state to the **filesystem** — plan, progress,
and decisions in files the agent re-reads — so any fresh agent can reconstitute where things stand and
continue.

This skill provides the long-horizon mechanics that [[autonomous-loops]] relies on. It composes
[[context-curation]] (what each turn reads), [[parallel-subagents]] (the worker fleet), and
[[agent-verification]] (the judge); it does not replace them.

## When to Use

- A task is **too large for one context window** and must span many sessions
- An agent must run **unattended for hours/days** across thousands of model invocations
- You're orchestrating a **planner / worker / judge** split (continuous exploration, focused execution,
  completion checks as distinct roles)
- A long run keeps **drifting, forgetting earlier decisions, or re-introducing fixed bugs**

**Skip** when the work fits comfortably in a single session — use [[orchestrated-delivery]] or a direct
task skill; this machinery is overhead you don't need for short work.

**Not a substitute for** [[autonomous-loops]] (the supervision/stop/triage discipline) or
[[agent-verification]] (trustworthy "done") — pair with both for an unattended long run.

## Process

### 1. Externalize the plan and the done-conditions
Write the goal, the **testable done-conditions**, and the task list to files **before** execution (a
PRD/feature list + a plan file). The agent edits these as understanding evolves — they are the source
of truth, not the chat history. Done-conditions written externally can't be redefined mid-run to
declare a premature win.

### 2. Keep an append-only progress log
Maintain a running `progress` file (e.g. `claude-progress.txt`) plus `CHANGELOG.md`: every meaningful
decision, what changed, and what's next — portable lab notes that survive resets and hand off cleanly.
Prefer **structured artifacts** (PRs, test output, briefs) over scrolling raw logs for auditing.

### 3. Commit meaningful units of work
Each completed unit is a commit ([[git-flow]]) — commits are your durable progress markers. Work that
isn't committed is work you can lose at the next context reset.

### 4. Compact context deliberately — don't let it rot
When the window fills, **summarize to a handoff file and reset** rather than letting quality degrade.
Reconstitute the next turn from the plan + progress + handoff, not from a bloated transcript
([[context-curation]]). Treat each reset as a clean baton-pass with a written handoff.

### 5. Make state reconstitutable
A fresh container/agent must be able to **rebuild where things stand** from the durable files alone:
read plan → read progress → read last handoff → resume. Test this: kill the session and confirm a cold
start continues correctly. This is what makes checkpoint-and-resume real, not aspirational.

### 6. Split roles for a long fleet (planner / worker / judge)
For big runs, separate **planner** (explores, maintains the plan), **workers** (execute scoped tasks,
in [[parallel-subagents]] / isolated worktrees), and **judge** (verifies completion, refuses bad
"done" per [[agent-verification]]). Avoid flat multi-agent setups sharing locks — they thrash and
churn. Coordinate through the plan file and PRs, not shared mutable state.

### 7. Govern memory drift
Watch for the **memory-reintroduction bug** (a fix in an early turn undone nine turns later) and for
procedural shortcuts learned from one odd interaction being applied everywhere. Re-derive against the
plan and tests, not against fuzzy recollection; let the progress log and the test suite be the memory.

### 8. Resume, don't restart
On crash or reset, run the reconstitution path (step 5) and continue from the last checkpoint — never
redo completed, committed work.

## Common Rationalizations

- "The context still has it." — Until it doesn't; long runs overflow every window. Durable state lives in files.
- "I'll summarize at the end." — Compact *before* rot sets in; degraded turns produce work you'll redo.
- "One big agent can hold it all." — It can't across hours; split planner/worker/judge and externalize state.
- "Logs are enough to audit." — Structured artifacts (PRs, tests, briefs) are tractable; raw log scrolling isn't.
- "Skip the commit, I'll do it later." — A reset between now and later loses it; commit each unit.
- "It remembers the earlier decision." — Memory drifts and re-introduces bugs; trust the plan and the tests.

## Red Flags

- The plan and done-conditions live only in the chat, not in files
- No progress/handoff file — a reset would lose context entirely
- Long stretches of work with no commits (nothing to resume from)
- Context allowed to fill to degradation instead of a deliberate compaction + reset
- A cold start can't reconstitute state from the durable files
- Flat multi-agent run sharing locks, thrashing on coordination
- A previously-fixed bug reappears later in the run (memory-reintroduction)

## Verification

- [ ] Goal, testable done-conditions, and task list written to external files before execution
- [ ] Append-only progress log + CHANGELOG maintained; structured artifacts preferred for audit
- [ ] Each meaningful unit committed as a durable progress marker ([[git-flow]])
- [ ] Context compacted to a handoff file and reset before quality degrades ([[context-curation]])
- [ ] State reconstitution tested — a cold start resumes correctly from files alone
- [ ] For fleets: planner/worker/judge roles split; coordination via plan + PRs, not shared locks
- [ ] No re-introduction of earlier fixes; plan and tests, not recollection, are the memory
