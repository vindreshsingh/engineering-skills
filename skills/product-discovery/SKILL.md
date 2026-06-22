---
name: product-discovery
description: Turns a raw idea into a decision-ready discovery package — validated problem, PRD with scope and success metrics, RFC handoff, and an ordered task breakdown — by running the PM persona trio (business-analyst, product-manager, product-analyst) through the Define and Plan phases. Use at the front of a feature when you have a one-line idea and need a buildable, measurable plan before any code.
---

# Product Discovery

The expensive failure on a feature happens before the first line of code: a vague idea becomes a PRD
nobody validated, with no success metric, no scope boundary, and no task plan — and the team builds the
wrong thing well. This skill is the **discovery conductor**: it drives a raw idea through the *Define*
and *Plan* phases as a system, running the product personas in sequence and gating on sign-off, so what
reaches the build phase is validated, scoped, measurable, and ordered.

It is the front half of [[orchestrated-delivery]], deepened for product rigor. It composes the
discovery skills — it does not replace them. Output is a **discovery package**, not code.

## When to Use

- You have a **one-line idea or goal** and need a buildable plan before committing engineering time
- A stakeholder asked for a feature and you need a PRD + scope + success metric + task breakdown
- Kicking off a new phase/epic that will span disciplines (frontend, backend, data)
- Before [[orchestrated-delivery]]'s Build phase, when Define/Plan haven't been done properly

**Skip** when:
- The change is a one-line fix or an isolated task — load that task's skill directly
- A validated spec + plan already exist — go straight to [[work-planning]] / Build
- You only need to sharpen one fuzzy idea with no PRD — use [[idea-shaping]] alone
- You only need a single PRD for an already-validated problem — use [[product-brief]] alone

**Not a substitute for** [[orchestrated-delivery]] (which carries the feature all the way to ship) or
the individual skills it sequences — it decides *which runs when* and *gates the handoff*.

## Process

Run the phases **in order**, each with a persona lens, a governing skill, and an **exit gate**. Keep
one written discovery doc as the source of truth. Stop for the user's sign-off at the marked gates —
do not barrel from idea to task plan in one unbroken pass.

### 1. Frame the problem — business-analyst lens
- Skill: [[idea-shaping]]. Separate the **real problem** from the proposed solution; surface the
  underlying user/business need, the assumptions, and the alternatives considered.
- Capture **who** has the problem, **how painful** it is, and **why now**. Flag ambiguity rather than
  guessing.
- **Gate:** the problem is stated independently of any one solution, and it's worth solving. If
  idea-shaping concludes "not worth building," **stop here** — that is a successful discovery outcome.

### 2. Define the product — product-manager lens
- Skill: [[product-brief]]. Write the **PRD**: epic + user stories ("As a … I want … so that …"),
  **testable acceptance criteria** per story, and **explicit scope vs out-of-scope**.
- Mark priority explicitly (**must** vs **later**); cut the PRD to a shippable first slice.
- **Gate (sign-off):** the user confirms the problem, scope, and must-have stories before planning.

### 3. Define success — product-analyst lens
- Skill: [[observability]] (metrics) tied back to the PRD. State the **primary success metric** and
  its target, the **hypothesis** the feature tests, and how it will be **instrumented**. Distinguish a
  leading signal from the lagging outcome.
- A feature with no measurable success criterion is not ready — send it back to step 2.
- **Gate:** every must-have story maps to an observable success signal.

### 4. Decide the design handoff — RFC or not
- If the feature touches contracts, schema, or cross-service boundaries, produce or request an **RFC**
  (`solution-architect`/`technical-architect`; [[interface-design]], [[data-modeling]],
  [[migration-path]] for breaking changes). If it's contained, note "no RFC needed" with one line of
  why ([[decision-docs]]).
- **Gate:** the design path is named — RFC drafted/requested, or explicitly waived with a reason.

### 5. Plan the work — team-lead lens
- Skill: [[work-planning]]. Break the scoped PRD into an **ordered, dependency-aware task breakdown**,
  each task with a "done" check. Mark which tasks are **independent** (parallelizable via
  [[parallel-subagents]]).
- **Gate (sign-off):** the plan is written, dependency-ordered, and the user approves it.

### 6. Assemble the discovery package
Produce the artifacts as separate, linked docs (mirror the repo's `docs/` convention — e.g.
`docs/specs/<feature>-prd.md`, `-rfc.md`, `-plan.md`, like the existing phase specs):

- **Problem brief** (step 1 outcome + decision)
- **PRD** — stories, acceptance criteria, scope/out-of-scope, priority (step 2)
- **Success metrics** — primary KPI, target, hypothesis, instrumentation (step 3)
- **RFC** or a recorded "no RFC" decision (step 4)
- **Task breakdown** — ordered, dependency-aware, parallelizable tasks marked (step 5)

### 7. Hand off to build
State the next step explicitly: load [[orchestrated-delivery]] (Build phase) or [[incremental-delivery]]
+ [[test-first]] against the task plan. Discovery is done when a builder could start without re-asking
*what* or *why*.

## Common Rationalizations

- "The idea is clear, skip straight to the PRD." — Then step 1 is a two-minute gate; run it and confirm the problem isn't the solution in disguise.
- "We'll figure out the metric later." — A feature with no success metric can't be evaluated or cut; define it before building (step 3).
- "Scope is obvious, no need to write out-of-scope." — Unwritten scope is the #1 source of mid-build creep; name it.
- "Just do the whole discovery in one pass." — Skipping the Define/Plan sign-off gates is how the wrong feature reaches build.
- "No RFC needed" (unstated). — Maybe true, but record *why* — an unwritten design decision resurfaces as a mid-build surprise.
- "Discovery means writing code spikes." — Discovery produces a validated, scoped, planned package; spikes are a Build-phase tool.

## Red Flags

- Jumping to a PRD with no problem validation (step 1 skipped)
- A PRD with no explicit out-of-scope section or no priority marking
- No primary success metric, or a metric with no target or instrumentation plan
- A design that changes a contract/schema with no RFC and no recorded waiver
- A "plan" that's a flat task list with no dependency order or "done" checks
- Barreling from idea to task plan with no sign-off at the Define and Plan gates
- The discovery package is one wall of text instead of linked, named artifacts

## Verification

- [ ] Problem framed independently of the solution; worth-building decision recorded ([[idea-shaping]])
- [ ] PRD written: stories, testable acceptance criteria, explicit scope/out-of-scope, priority
- [ ] Primary success metric with target, hypothesis, and instrumentation defined; every must-have story maps to a signal
- [ ] Design path named — RFC drafted/requested or explicitly waived with a reason ([[decision-docs]])
- [ ] Ordered, dependency-aware task breakdown with per-task "done" checks; parallelizable tasks marked
- [ ] User sign-off taken at the Define and Plan gates
- [ ] Artifacts produced as separate linked docs and handed off to Build with the next step named
