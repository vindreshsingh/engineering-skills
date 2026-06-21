---
name: parallel-subagents
description: Dispatches independent tasks to parallel subagents and integrates their results for faster, focused execution. Use when a plan has multiple independent tasks, or a task is large enough to delegate to a fresh focused agent.
---

# Parallel Subagents

A subagent is a fresh, focused worker with its own clean context. Dispatching independent tasks in
parallel is faster and keeps each agent's context lean — but a subagent **starts cold**, so a vague
brief or a hidden dependency turns the speedup into a mess of conflicts and rework. Dispatch only what's
truly independent, brief it completely, and verify what comes back.

## When to Use

- A plan ([[work-planning]], [[orchestrated-delivery]]) has multiple **independent** tasks
- A task is large or self-contained enough to hand to a focused agent
- You want to keep the main thread's context lean ([[context-curation]]) by offloading detail

Don't use it to parallelize tasks that share state or have ordering dependencies — those stay
sequential.

## Process

1. **Separate independent from dependent work.** Only dispatch tasks with no shared mutable state and
   no ordering dependency on each other. If task B needs A's output, they are sequential — do not
   parallelize them.
2. **Write a self-contained brief per subagent.** It cannot see this conversation. Include: the goal,
   the context/background it needs, the **skill(s) to follow**, the exact files/paths, and the
   **acceptance criteria** that define done.
3. **Constrain scope to one clear deliverable.** One task, one outcome — don't let a subagent wander
   into adjacent work.
4. **Dispatch in parallel and collect results.**
5. **Integrate and verify.** Review each result against its acceptance criteria, resolve any conflicts
   at the integration points, and run the tests on the **combined** result — not just each piece.
6. **Keep the source-of-truth plan current** — mark tasks done as their results land and verify.

## Common Rationalizations

- "Dispatch everything for speed." — Parallelizing dependent tasks creates conflicting edits and rework.
- "The subagent already has the context." — It doesn't; it cold-starts. Put everything in the brief.
- "I'll integrate without reviewing." — Unverified merges combine three plausible-but-wrong results into one bug.
- "One big subagent task is fine." — Unscoped tasks wander; one deliverable per agent.

## Red Flags

- Tasks with hidden dependencies dispatched in parallel → conflicting changes
- Briefs that assume conversation context the subagent never had
- Subagent output merged without checking it against acceptance criteria
- Combined result never tested as a whole
- No source-of-truth plan; lost track of what each agent did

## Verification

- [ ] Only independent tasks were dispatched in parallel; dependent ones sequenced
- [ ] Each brief was self-contained (goal, context, skill, paths, acceptance criteria)
- [ ] Each subagent had one clearly scoped deliverable
- [ ] Results were integrated and verified against acceptance criteria
- [ ] The combined result passes its tests; the plan was kept current
