---
name: orchestrated-delivery
description: Drives a feature end-to-end through the full lifecycle — define, plan, build, verify, review, ship — loading the right skill and persona at each phase, gating on sign-off, and dispatching independent work to parallel subagents. Use for any non-trivial feature or project, not a single small edit.
---

# Orchestrated Delivery

This is the **conductor**. Most failure on a real feature isn't bad code — it's jumping straight to
code, skipping the spec, building the wrong thing, and discovering it at the end. Orchestrated delivery
runs the work through the lifecycle as a *system*: at each phase it loads the governing skill, adopts
the right persona, **gates on exit criteria** (and on your sign-off where it matters), and dispatches
independent work in parallel — instead of one agent improvising the whole thing in a single pass.

This skill composes the others; it does not replace them. It decides *which* skill and *which* persona
runs *when*, and refuses to advance a phase whose exit criteria aren't met.

## When to Use

- Any feature or project beyond a single small change
- Work that spans disciplines (frontend + backend + data + ops) or multiple tasks
- When you want the persona org (`agents/sdlc/…`) to act as a coordinated team, not a roster
- Coordinating multi-step work that benefits from parallel execution

Skip for a one-line fix or a single isolated task — load that task's skill directly.

## Process

Run the phases **in order**. Each phase has a governing skill, a persona lens, and an **exit gate**.
Do not advance until the gate is met. Keep a single written plan as the source of truth throughout.

### 1. Define — what & why
- Persona: `product-manager` / `business-analyst`. Skills: [[idea-shaping]] → [[spec-first]] (and
  [[product-brief]] for stakeholder sign-off).
- **Gate:** a short spec exists with testable requirements and acceptance criteria, scope and
  out-of-scope named. **Get the user's sign-off before planning.**

### 2. Plan — how & in what order
- Persona: `solution-architect`/`technical-architect` for design, then `team-lead` for breakdown.
  Skills: [[interface-design]], [[data-modeling]] for contracts; [[work-planning]] for the task plan.
- Produce an **ordered, dependency-aware task breakdown** across disciplines, and mark which tasks are
  **independent** (parallelizable).
- **Gate:** the plan is written, dependency-ordered, each task has a "done" check. **User signs off.**

### 3. Build — implement the plan
- Execute task by task with [[incremental-delivery]] + [[test-first]]. Adopt the matching developer
  persona per task (`frontend-developer`, `backend-developer`, `database-engineer`) and apply the
  domain skill it needs ([[hardening]], [[resilience]], [[react-patterns]], [[accessibility]],
  [[caching-strategy]]…).
- **Dispatch independent tasks to parallel subagents** ([[parallel-subagents]]); keep dependent tasks
  sequential. Update the source-of-truth plan as each task completes.
- **Gate:** every task is implemented and individually verified before it's marked done.

### 4. Verify — prove it works
- Skills: [[browser-checks]] for UI, run the test suite, check the spec's acceptance criteria.
- **Gate:** acceptance criteria pass against the running system, not by assertion.

### 5. Review — correctness & safety
- Persona: `code-reviewer`, `security-auditor`, `technical-qc`. Skills: [[review-gate]],
  [[hardening]], [[perf-budget]] where relevant.
- **Gate:** no blocking findings; implementation conforms to the spec and the agreed design.

### 6. Ship — release safely
- Persona: `release-manager`. Skills: [[launch-readiness]] (rollout, monitoring, rollback),
  [[migration-path]] if a contract/schema changed.
- **Gate:** gradual rollout planned, rollback tested, monitoring live.

### 7. Operate (as needed)
- [[observability]] in place; `incident-commander` + [[incident-response]] on standby.

Throughout: **show work in digestible chunks** and stop at the Define and Plan gates for sign-off —
don't barrel from request to shipped code in one unbroken run.

## Common Rationalizations

- "Just start coding, we'll plan as we go." — Planning-as-you-go is how you build the wrong thing twice.
- "The spec is obvious, skip to build." — Then the gate is free; write it and move on in two minutes.
- "Do the whole thing in one pass." — A single undifferentiated run skips the gates that catch mistakes early.
- "Run the independent tasks one at a time." — Wasted wall-clock; dispatch them in parallel.
- "Verify at the very end." — Phase gates catch failures while they're cheap, not after they compound.

## Red Flags

- Build started with no agreed spec or plan
- One giant task instead of a dependency-ordered breakdown
- No sign-off at the Define/Plan gates — request to shipped code in one unbroken run
- Independent tasks executed serially when they could parallelize
- A phase advanced with its exit criteria unmet
- No single source-of-truth plan; nobody can say what's done

## Verification

- [ ] Phases ran in order; each phase's exit gate was met before advancing
- [ ] Spec and plan were signed off before Build
- [ ] The governing skill and persona were loaded at each phase/task
- [ ] Independent tasks were dispatched in parallel; dependent ones sequenced
- [ ] Each task was verified before being marked done; acceptance criteria checked on the running system
- [ ] Reviewed across the five lenses and shipped via [[launch-readiness]] with a tested rollback
- [ ] A single written plan was kept current throughout
