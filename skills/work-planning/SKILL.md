---
name: work-planning
description: Breaks a spec or task into an ordered, verifiable plan before building. Use when work spans multiple steps or files, when several people will collaborate, or when you need an estimate.
---

# Work Planning

Turn "build the feature" into a sequence of small steps where each one can be finished and checked on
its own. A plan exposes hidden dependencies and unknowns before they become mid-build surprises.

## When to Use

- The work is more than an hour or touches more than a couple of files
- There are ordering constraints (migration before code, API before UI)
- Multiple people or sessions will pick the work up
- You need a credible estimate or a place to track progress

## Process

1. **Start from the spec or goal.** If there isn't one, write a one-paragraph version first
   (see [[spec-first]]).
2. **List the deliverables** — the concrete artifacts that must exist when done.
3. **Decompose into tasks** that are each independently verifiable and ideally under a day. If a task
   is fuzzy or large, split it until it isn't.
4. **Order by dependency, not by comfort.** Do the thing that unblocks the most other things, and the
   riskiest unknown, early.
5. **Mark the risky tasks** and add a spike/prototype step where you're genuinely unsure.
6. **Define the check for each task** — the test, command, or observation that says it's done.
7. **Keep the plan visible and current.** Tick items off; re-plan when reality diverges.

A good plan is a checklist you can hand to someone else and they'd know what "done" means at each step.

## Common Rationalizations

- "I'll keep the plan in my head." — Then no one else can see status and you lose it on a context switch.
- "Planning is overhead." — Ten minutes of ordering saves hours of rework from a wrong build order.
- "The tasks are obvious." — Write the obvious ones down; the gaps between them are where work hides.
- "We'll estimate once we start." — Estimating without decomposition is guessing.

## Red Flags

- A single task called "implement the feature"
- Tasks with no defined way to tell they're finished
- Front-loading the easy work and leaving the risky unknown for last
- The plan hasn't been touched since the work started
- No task addresses testing, migration, or rollout

## Verification

- [ ] Deliverables listed explicitly
- [ ] Tasks are small and independently checkable
- [ ] Ordered by dependency; riskiest unknowns scheduled early
- [ ] Each task has a concrete "done" check
- [ ] The plan is written down somewhere shared and kept up to date
