---
name: spec-first
description: Writes a short, testable specification before implementation. Use when starting a new project, feature, or non-trivial change, when requirements are vague or ambiguous, or before estimating, planning, or handing work to others.
---

# Spec First

Decide *what* and *why* on paper before writing *how* in code. A spec is a cheap place to be wrong —
changing a paragraph costs minutes; changing shipped code costs days. A good spec is **short,
testable, and disagreed-with early** — not a design doc that pretends every question is answered.

**Define phase chain:** [[idea-shaping]] (worth building?) → [[product-brief]] (stakeholder alignment,
when needed) → **spec-first** (engineering spec) → [[work-planning]] (tasks) →
[[incremental-delivery]] + [[test-first]] (build). Record significant choices in [[decision-docs]].

Pair with [[interface-design]] when the spec defines API boundaries, [[design-handoff]] when UI behavior
is specified, [[migration-path]] when the change breaks callers, and [[source-first]] when the spec
must reflect how the system works today.

## When to Use

- A new project, feature, endpoint, schema change, or non-trivial refactor
- The request is a vague sentence ("add notifications", "make it faster")
- More than one reasonable interpretation exists
- The change touches several modules, teams, or shared contracts
- You are about to estimate, break down ([[work-planning]]), or hand work to someone else
- A bug fix needs clarified expected behavior ([[fault-recovery]] blocker when "expected" is disputed)
- AI/agent is about to implement — give it a contract, not a vibe

**Skip** for genuinely trivial edits — typo, copy tweak, one-line fix with obvious behavior. **Skip**
when [[idea-shaping]] hasn't confirmed pursue on a fuzzy initiative — shape first, don't spec a maybe.

**Not a substitute for** [[product-brief]] — cross-team PRD/RFC sign-off lives there; spec-first is the
**engineering implementation spec** engineers build and test against.

| Situation | Use |
|-----------|-----|
| Fuzzy one-liner, worth unknown | [[idea-shaping]] first |
| Multi-stakeholder PRD / platform RFC | [[product-brief]] → then spec-first |
| One team, clear problem, ready to build | **spec-first** |
| Locked PRD approved | **spec-first** (derive testable requirements) |

## Process

Work in order. Stop and ask when the goal isn't one sharp sentence.

### 1. Confirm you're spec-ready

Before writing requirements:

- [ ] **Problem is shaped** — who, pain, and pursue decision ([[idea-shaping]]) or approved brief
      ([[product-brief]])
- [ ] **Owner exists** — someone can answer open questions
- [ ] **Rough size known** — not a multi-quarter initiative without a brief/RFC slice

If any fail, step back — specifying an unshaped idea produces fiction.

### 2. Restate the goal in one sentence

If you cannot, you don't understand the request yet — ask.

```text
Good: "Logged-in sellers can duplicate an existing listing as a draft in one click."
Bad:  "Improve the listing experience."
```

The sentence is the **north star** — every requirement should trace to it.

### 3. Capture problem and context — briefly

Even in an engineering spec, one short **problem** paragraph prevents solution-only specs:

- **Who** uses this (role, not "users")
- **Pain today** — what they do without it, what goes wrong
- **Why now** — if not obvious from the ticket

Don't re-run full [[idea-shaping]] — three sentences max unless the brief already covers it.

### 4. Describe scenarios — the flows that matter

List **concrete scenarios** (user or system), not feature bullet soup:

```text
1. Seller clicks "Duplicate" on published listing → draft created with copied fields → lands on edit screen
2. Seller duplicates while at listing limit → clear error, no partial draft
3. Guest hits duplicate URL → redirect to login with return path
```

Each scenario becomes a **test candidate** ([[test-first]]). Cover:

- **Happy path** — the reason we're building
- **Primary alternates** — empty state, first-time, power-user
- **Failure paths** — validation, permissions, dependency down (pointer to [[resilience]] if non-trivial)

### 5. Write testable requirements

Requirements are **observable statements** someone can verify — not adjectives.

```text
Bad:  "The page should be fast and intuitive."
Good: "Search results render within 2s p95 on 4G for 20-item result set ([[perf-budget]])."
Good: "Keyboard users can complete checkout without a mouse ([[accessibility]])."
Good: "A logged-out user hitting /dashboard is redirected to /login?returnUrl=…"
```

Structure:

| ID | Requirement | Priority |
|----|-------------|----------|
| R1 | … | Must |
| R2 | … | Must |
| R3 | … | Nice |

**Must** = ship blocker. **Nice** = explicitly deferrable without renegotiating success.

Use **Given / When / Then** for complex rules when plain prose gets ambiguous.

### 6. Declare out of scope — explicitly

Scope creep starts with unstated assumptions. List what **this change does not do**:

```text
Out of scope:
- Bulk duplicate (single listing only in v1)
- Copying analytics/history to the new listing
- Mobile native app (web responsive only)
```

If stakeholders might expect it, say **no** here — not silence.

### 7. Note non-functional requirements — only what matters

Don't boilerplate everything — call out NFRs that **change design**:

| Area | Example in spec | Skill if deep |
|------|-----------------|---------------|
| Security | "Only listing owner or admin can duplicate" | [[hardening]] |
| Performance | "Duplicate API p95 < 500ms" | [[perf-budget]] |
| Accessibility | "Duplicate action keyboard-accessible, announced to SR" | [[accessibility]] |
| Observability | "Emit `listing.duplicated` event with source id" | [[observability]] |
| Compatibility | "Existing listing URLs unchanged" | [[migration-path]] |

One line each unless the feature *is* the NFR (e.g. audit log).

### 8. Sketch the approach — high level, not pseudo-code

Enough for [[work-planning]] and review — not an implementation manual:

- **Data** — new tables/fields? migrations? ([[data-modeling]])
- **Interfaces** — new endpoints, events, UI surfaces ([[interface-design]])
- **Dependencies** — third-party, feature flags, other teams
- **Key decisions** — and alternatives considered in one line each ([[decision-docs]] if lasting)

```text
Approach sketch:
- POST /listings/:id/duplicate → new draft row, copy scalar fields, async copy images
- Reuse ListingDraftEditor; add Duplicate button on ListingDetail (owner only)
- Flag: listings.duplicate_enabled (default off in prod until launch)
```

Flag **spikes** for unknowns ("image copy latency unknown — spike in day 1").

### 9. Edge cases, errors, and open questions

**Edge cases** — answer in spec when cheap; defer with owner when not:

```text
- Source listing deleted mid-duplicate → 404, no orphan draft
- Source is already a draft → allow duplicate? YES (copy draft as new draft)
```

**Open questions** — table with owner and resolution date:

| Question | Owner | By when |
|----------|-------|---------|
| Copy scheduled publish date? | PM | Before build |
| Max duplicates per day? | — | Default: no limit v1 |

Unresolved **must-haves** block [[work-planning]] — nice-to-haves can defer.

**Risks** — what could make this wrong or late; mitigations in one line.

### 10. Define done — observable acceptance criteria

"Done" is not "code merged." It's **observable conditions**:

```text
Done when:
- [ ] R1–R5 pass in staging
- [ ] Duplicate flow verified in browser ([[browser-checks]])
- [ ] Migration applied; rollback steps documented ([[launch-readiness]])
- [ ] Analytics event visible in dashboard
- [ ] Feature flag off by default; runbook for enable
```

Tie back to requirement IDs. This becomes the **review checklist** for [[review-gate]].

### 11. Keep it short — then review

- **Target: one page** for most features; two max with scenarios table
- Put depth in **links** — brief, Figma, RFC, ADR — not duplication ([[context-curation]])
- **Second read** for significant changes — author + one other (eng, PM, or design)
- Disagreement in review **updates the spec** — not side-channel Slack truth

After approval → [[work-planning]] to decompose, then [[incremental-delivery]].

### 12. Keep the spec living

Specs go stale when decisions change silently:

- Update the spec when scope or behavior changes mid-build
- Mark deferred items — don't delete requirements without noting why
- Close open questions in the doc when resolved
- If the spec and code diverge, **fix one** — usually code wrong until release; spec wrong after

## Spec skeleton (copy and trim)

```markdown
# [Feature] — Spec
Status: Draft | Review | Approved
Author: … | Reviewers: …

## Goal (one sentence)
…

## Problem & context
…

## Scenarios
1. …
2. …

## Requirements
| ID | Requirement | Priority |
|----|-------------|----------|
| R1 | … | Must |

## Out of scope
- …

## Non-functional (if any)
- …

## Approach sketch
- …

## Edge cases & errors
- …

## Open questions
| Question | Owner | By |

## Risks
- …

## Done when
- [ ] …
```

## Common Rationalizations

- "It's faster to just code it." — Faster to start, slower when you build the wrong thing.
- "The requirements are obvious." — Writing them down takes minutes; silent disagreement takes weeks.
- "Specs go stale." — Update them; a missing spec hides drift until launch.
- "I'll document it after." — After docs describe what you built, not what was needed.
- "The PRD already covers it." — PRDs aren't testable eng contracts; derive R1, R2, done-when.
- "Edge cases during implementation." — Cheap in spec, expensive in prod and review rework.
- "One page isn't enough." — If it doesn't fit, split the feature ([[incremental-delivery]]), not the doc length.

## Red Flags

- Cannot state the goal in one sentence
- "We'll figure out edge cases as we go"
- Requirements that are adjectives ("fast", "clean", "intuitive") with no measurable meaning
- Two engineers describe the feature differently
- Implementation started and scope still debated
- No out-of-scope section on a user-facing feature
- Open questions with no owner blocking planning
- Spec duplicates entire PRD — no testable requirements extracted
- "Done" = "merged" with no observable acceptance criteria

## Verification

- [ ] Spec-ready — problem shaped or brief approved; owner identified
- [ ] Goal stated in one sentence; scenarios cover happy, alternate, and key failure paths
- [ ] Requirements concrete, testable, and prioritized (must vs nice)
- [ ] Out-of-scope list explicit
- [ ] NFRs noted only where they change design
- [ ] Approach sketched at high level; spikes flagged for unknowns
- [ ] Edge cases answered or deferred with owner; risks named
- [ ] Done defined as observable conditions tied to requirements
- [ ] Spec short enough to read; reviewed if significant
- [ ] Handoff clear to [[work-planning]] / [[incremental-delivery]] / [[test-first]]
