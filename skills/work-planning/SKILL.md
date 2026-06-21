---
name: work-planning
description: Breaks a spec or goal into an ordered, verifiable plan before building. Use when work spans multiple steps or files, when collaboration or handoff is needed, or when you need a credible estimate and visible progress.
---

# Work Planning

Turn "build the feature" into a sequence of **small, checkable steps** where each one can finish and
be verified on its own. A plan exposes hidden dependencies, ordering mistakes, and unknowns **before**
they become mid-build surprises — when changing a paragraph is cheap.

Planning is not bureaucracy — it's the cheapest place to discover that the API must ship before the UI,
the migration blocks everything, or nobody owns the open question.

**Plan phase chain:** [[spec-first]] (what) → **work-planning** (ordered tasks) →
[[incremental-delivery]] (build slice by slice) + [[test-first]] (prove each step). Record lasting
decisions in [[decision-docs]]; risky rollouts get [[migration-path]] and [[launch-readiness]] tasks.

Pair with [[context-curation]] — one working set per plan step — and [[git-flow]] for commit/checkpoint
rhythm during execution.

## When to Use

- Work is more than ~an hour or touches more than a couple of files
- Ordering constraints exist — migration before code, API before UI, flag before exposure
- Multiple people, agents, or sessions will pick up the work
- You need a **credible estimate**, sprint scope, or shared progress tracker
- Before [[incremental-delivery]] on any non-trivial feature
- Stakeholders ask "how long" or "what's left" — decomposition is the honest answer

**Skip** for trivial, single-step edits (typo, one-line fix with obvious done state). **Skip** when
[[spec-first]] isn't ready — open must-have questions block a plan that's fiction.

**Not a substitute for** [[spec-first]] — planning orders the work; it doesn't invent requirements.
**Not sprint ceremony** — Scrum Master facilitates; this skill produces the **task breakdown** those
ceremonies consume.

| Input ready? | Action |
|--------------|--------|
| Vague idea | [[idea-shaping]] → [[spec-first]] first |
| Approved spec / clear ticket | **work-planning** |
| Plan exists, start coding | [[incremental-delivery]] |

## Process

Work in order. Write the plan where others can see it — ticket, doc, PR description, not your head.

### 1. Start from an explicit goal and spec

Inputs:

- **Spec or ticket** with goal, requirements, out-of-scope ([[spec-first]])
- **Constraints** — deadline, team, feature flags, compliance, backwards compatibility
- **Definition of done** from spec — observable acceptance criteria

If there's only a one-liner, write a **one-paragraph goal + 3 bullets of scope** before decomposing —
or go back to [[spec-first]].

```text
Goal: Sellers can duplicate a listing as a draft in one click.
Done when: R1–R5 in spec pass in staging + flag off by default.
Out of scope: bulk duplicate (v1).
```

### 2. List deliverables — artifacts that must exist

Deliverables are **nouns**, not activities:

```text
Deliverables:
- POST /listings/:id/duplicate endpoint
- Duplicate button on ListingDetail (owner only)
- Migration: drafts.source_listing_id column
- Analytics event listing.duplicated
- Runbook for feature flag enable
```

Include non-code artifacts when the spec demands them — docs, alerts, dashboards ([[observability]]).

### 3. Map dependencies and unknowns

Draw the **critical path** — what blocks what:

```text
Migration (nullable column) → API can write source_listing_id → UI can call API
Feature flag config → UI button visibility
Open question: copy images sync vs async? → SPIKE before API estimate firm
```

| Type | Plan response |
|------|----------------|
| **Hard dependency** | Order tasks — blocker first |
| **Soft dependency** | Parallel with interface stub ([[interface-design]]) |
| **Unknown** | Spike task with time box + decision output |
| **External dependency** | Task + owner + follow-up date |

Schedule **riskiest unknowns early** — not after easy UI polish ([[incremental-delivery]] walking skeleton).

### 4. Decompose into tasks — independently verifiable

Each task should be:

- **Completable in ≤ 1 day** (ideal: half-day) — if fuzzy or bigger, split
- **Independently verifiable** — clear done check without waiting for the whole feature
- **Named as outcome** — "Duplicate API returns draft id" not "work on backend"

**Split patterns:**

| Too big | Split into |
|---------|------------|
| "Build checkout" | Cart API → payment redirect → confirmation email |
| "Add auth" | Login endpoint → session cookie → protected route guard |
| "Implement design" | List skeleton → row component → empty/error states ([[ui-craft]]) |

Prefer **vertical slices** in ordering when using [[incremental-delivery]] — each task should enable
something demoable or testable, not "all models" with zero behavior.

### 5. Order tasks — dependency first, not comfort

Order rules:

1. **Spikes / proofs** for unknowns (time-boxed)
2. **Schema / contract** that others depend on ([[data-modeling]], [[interface-design]])
3. **Walking skeleton** — thinnest end-to-end path ([[incremental-delivery]])
4. **Expand happy path** — remaining requirements
5. **Edge cases, error states, polish**
6. **Hardening** — perf, security pass, a11y ([[hardening]], [[accessibility]])
7. **Ship tasks** — flag, monitoring, rollback doc ([[launch-readiness]])

Don't front-load easy CSS while API shape is unset.

### 6. Add spikes where you're guessing

A **spike** is time-boxed learning with a **written answer**, not production code:

```text
Spike (4h): Copy listing images — sync copy vs async job?
Output: Decision + approach sketch in ticket; tasks 4–6 updated.
```

Spike outputs: feasibility yes/no, estimate refinement, chosen approach — or escalate to [[spec-first]].

### 7. Define "done" for every task

Every task needs a **check** — test, command, or observation:

| Task | Done when |
|------|-----------|
| Duplicate API | Integration test green; POST returns 201 + draft id |
| Duplicate button | Owner sees button; guest doesn't; click creates draft ([[browser-checks]]) |
| Migration | Applied on staging; rollback script noted ([[migration-path]]) |
| Feature flag | Default off in prod config; runbook linked |

Vague "done" = task isn't ready. Link to spec requirement IDs when useful ([[spec-first]]).

### 8. Estimate when needed — after decomposition

Estimates before decomposition are guesses. After:

- Sum tasks with **explicit uncertainty** on spikes (+range on unknowns)
- Call out **sequential vs parallel** — two devs can't both own the same blocker chain without coordination
- Include **review, QA, deploy** if the estimate is for "in prod" not "code complete"
- Prefer **relative sizing** (S/M/L) per task if hours are political — but map L to "must split"

```text
Bad:  "Feature: 2 weeks"
Good: "8 tasks × 0.5–1d + 4h spike + 1d review/deploy buffer = ~6–8 dev-days"
```

### 9. Include the tasks people forget

Checklist — add tasks if the spec requires them:

- [ ] Tests ([[test-first]]) — unit/integration per slice; regression for bugs
- [ ] Migration + backfill + rollback ([[migration-path]])
- [ ] Feature flag / config / env vars documented
- [ ] Observability — logs, metrics, alerts ([[observability]])
- [ ] Security — authz on new endpoints ([[hardening]])
- [ ] Browser verification for UI ([[browser-checks]])
- [ ] Docs / ADR / runbook ([[decision-docs]], [[launch-readiness]])
- [ ] PR self-review + CI ([[git-flow]], [[pipeline-ops]])

Missing rollout tasks is how "code done" ≠ "shipped."

### 10. Write the plan — format that travels

Keep it in the ticket or linked doc — copy-friendly template:

```markdown
# Plan: [Feature name]
Goal: …
Spec link: …

## Deliverables
- …

## Dependencies / risks
- …

## Tasks (ordered)
| # | Task | Owner | Done when | Est |
|---|------|-------|-----------|-----|
| 1 | Spike: image copy approach | @dev | Decision doc in ticket | 4h |
| 2 | Migration: source_listing_id | @dev | Staging migrated | S |
| 3 | POST …/duplicate API | @dev | Integration test green | M |
| 4 | Duplicate button + flag | @dev | Browser check passed | M |
| 5 | Launch: flag runbook | @dev | Runbook in wiki | S |

## Out of plan / deferred
- Bulk duplicate → v2
```

For agents: one **current task** in focus ([[context-curation]]); complete its done check before advancing.

### 11. Execute and keep the plan current

During build:

- **Mark tasks complete** as done checks pass — not when "mostly done"
- **Re-plan when reality diverges** — new dependency, spike failed, scope cut; update the table
- **Don't hide blockers** — stuck task → explicit blocker line with owner
- Hand each task to [[incremental-delivery]] loop: implement → verify → commit ([[git-flow]])

A plan nobody updates becomes fiction; a 5-minute re-plan saves days of wrong order.

### 12. Hand off clearly

When passing to another person or session:

- **Current task #** and what's done
- **Next task** with done check
- **Open questions** with owners
- **Branch / PR** state ([[git-flow]])

Planning ends when build starts — but the doc **lives until all tasks are checked**.

## Common Rationalizations

- "I'll keep the plan in my head." — No one else sees status; context switch erases it.
- "Planning is overhead." — Ten minutes of ordering saves hours of wrong build order.
- "The tasks are obvious." — Write them; gaps between obvious tasks hide work.
- "We'll estimate once we start." — Decompose first or admit the estimate is a guess.
- "One task: implement feature." — Not a plan; not reviewable; not estimable.
- "We'll add test/deploy tasks at the end." — They won't happen under pressure.
- "Spikes are waste." — Building the wrong architecture is the waste.
- "The spec is the plan." — Spec says what; plan says order, dependencies, and checks.

## Red Flags

- Single task: "implement the feature"
- Tasks with no defined done check
- Easy work front-loaded; risky unknown last
- Plan untouched since work started
- No tasks for tests, migration, flags, or rollout
- Parallel tasks on the same critical path without coordination
- Estimate is one number with no task list
- Open spec questions with no spike or owner blocking start
- "Done" means "code written" but not verified
- Plan exists only in chat, not in the ticket

## Verification

- [ ] Goal and spec (or equivalent) explicit; out-of-scope noted
- [ ] Deliverables listed as concrete artifacts
- [ ] Dependencies mapped; unknowns have spikes or owners
- [ ] Tasks ≤ ~1 day each, outcome-named, independently verifiable
- [ ] Ordered by dependency; riskiest work early
- [ ] Every task has a concrete done check (test, command, observation)
- [ ] Forgotten-work checklist addressed — tests, migration, ship, observability
- [ ] Estimates grounded in tasks (if estimating)
- [ ] Plan written in a shared place and updated as work progresses
- [ ] Handoff to [[incremental-delivery]] clear — first slice identified
