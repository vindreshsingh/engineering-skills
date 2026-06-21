---
name: product-brief
description: Writes a product brief / PRD or technical RFC that aligns stakeholders before building. Use when a feature needs sign-off across teams, a significant technical approach needs review, or you need a durable record of what and why (or how) before commitment.
---

# Product Brief

A brief exists to get people **aligned before the work starts** — what we're building and why (PRD), or
how we propose to build it (RFC). Its job is to **surface disagreement early** while it's cheap, give
everyone **one source of truth**, and produce a **reviewed decision** engineering can execute against.

A brief is not a novel. A two-page PRD with clear metrics beats a forty-page doc nobody reads. A RFC
with honest alternatives beats a design that pretends the chosen path is the only path.

**Define phase chain:** [[idea-shaping]] (is it worth it?) → **product-brief** (align stakeholders) →
[[spec-first]] (testable engineering spec) → [[work-planning]] (tasks). Record settled decisions in
[[decision-docs]].

## When to Use

**Product brief / PRD** — the *what* and *why*:

- Feature or initiative needs **sign-off** across product, engineering, design, support, legal
- Multiple stakeholders own success metrics or scope boundaries
- Estimation or staffing needs a shared scope document
- Executive or customer commitment requires written alignment

**Technical RFC** — the *how*:

- Significant architecture, platform, or migration choice before coding
- Cross-team technical contract (API, data model, infra) needs review
- Trade-offs affect performance, security, cost, or operability for years
- Alternatives exist and reviewers must trust the pick

**Both** — large initiatives: PRD for user outcomes + RFC for technical approach (can be one doc with
clear sections).

Skip when [[idea-shaping]] hasn't confirmed pursue — don't PRD a idea still fuzzy. Skip RFC for small
changes with one obvious approach inside one team — go to [[spec-first]].

## Process

### 1. Choose the artifact — PRD, RFC, or both

| Situation | Artifact |
|-----------|----------|
| User-facing feature, unclear scope | PRD |
| Platform change, no new UX | RFC |
| Big initiative (marketplace, new billing) | PRD + RFC |
| Small API addition, one team | [[spec-first]] may suffice |
| Exec said "build X" | [[idea-shaping]] first, then PRD |

Name the **author**, **reviewers**, and **decision date** at the top — accountability matters.

### 2. Write the product brief / PRD

Ground in evidence from [[idea-shaping]] when available — don't restart from a solution slogan.

**Template:**

```markdown
# [Feature name] — Product Brief
Status: Draft | In review | Approved
Author: … | Reviewers: … | Target release: …

## Problem & audience
Who has the pain? What do they do today? Evidence (data, quotes, support volume) — not assertion.

## Why now
Strategic fit, market, regulation, competitive pressure, technical enabler.

## Goals & success metrics
Primary metric + target (e.g. publish rate +10% in 90 days).
Guardrail metrics (don't harm conversion, latency, support volume).

## Scope — in
Must-have behaviors for this release (bullet list).

## Scope — out
Explicitly deferred (prevents scope creep in review).

## User stories / requirements (prioritized)
Must / should / could — each testable:
- As a seller, I see a suggested price range when listing, so I can publish confidently.

## Dependencies
Teams, APIs, legal, design, data, third parties.

## Risks & mitigations
| Risk | Mitigation |
|------|------------|

## Open questions
| Question | Owner | Due |
|----------|-------|-----|

## Non-goals
What we are deliberately not solving.
```

**Requirements must be testable** — "fast checkout" fails; "guest checkout completes in < 3 steps" passes
(hand detailed criteria to [[spec-first]]).

**Success metrics** need baseline + target + measurement method ([[observability]] hooks planned).

### 3. Write the technical RFC

For *how* we'll build after (or alongside) product alignment:

```markdown
# RFC: [Title]
Status: Draft | In review | Accepted | Superseded
Author: … | Reviewers: …

## Context & problem
Current system, constraints, scale, why change now. Link PRD if user-driven.

## Goals & non-goals
Technical outcomes (latency, reliability, cost) — not duplicate entire PRD.

## Proposed design
Architecture diagram (simple), components, data flow, key interfaces ([[interface-design]]).
Migration impact if any ([[migration-path]]).

## Alternatives considered
| Option | Pros | Cons | Why not |
|--------|------|------|---------|
| A — chosen | … | … | |
| B | … | … | rejected because … |
| C — do nothing | … | … | |

## Trade-offs & impact
Performance, security ([[hardening]]), operability, cost, team ownership, timeline.

## Rollout plan
Phases, flags, backward compatibility ([[launch-readiness]], [[incremental-delivery]]).

## Open questions
| Question | Owner | Due |

## Appendix
Diagrams, spike results, benchmarks ([[perf-budget]]).
```

**Alternatives section is mandatory** — reviewers trust RFCs that show roads not taken ([[decision-docs]]).

### 4. Circulate for review — structured feedback

Before "Approved":

1. **Share early draft** — async comment window (48–72h minimum for cross-team)
2. **List reviewers explicitly** — product, eng lead, security if needed, support, legal for sensitive
3. **Review meeting** only if async left blocking disagreements — with pre-read required
4. **Capture decisions** in doc — don't rely on meeting memory
5. **Resolve open questions** — answer, defer with owner/date, or descope

**Feedback types:**

| Type | Action |
|------|--------|
| Clarification | Edit doc |
| Scope change | Update in/out; re-review if large |
| Technical blocker | RFC amendment or spike ticket |
| Disagreement on approach | Escalate with alternatives table; decision recorded |

**Approval** means: stakeholders accept scope, metrics, and approach — not "everyone loves it."

### 5. Gate implementation — no build on open blockers

Do **not** start [[work-planning]] / [[incremental-delivery]] while:

- Open questions block core flow or success metric
- Security/legal review outstanding for regulated features
- RFC alternatives unresolved — "we'll pick in sprint 1"

Allowed parallel work: spikes time-boxed to answer open questions ([[idea-shaping]] validation),
design exploration — not production feature code on contested scope.

### 6. Hand off to engineering artifacts

| From brief | To | What transfers |
|------------|-----|----------------|
| Approved PRD | [[spec-first]] | Testable requirements, edge cases, done definition |
| Approved RFC | [[spec-first]] + [[interface-design]] | Contracts, migration steps |
| Either | [[work-planning]] | Ordered tasks, estimates |
| Significant choice | [[decision-docs]] | ADR extracted from RFC alternatives |
| Launch | [[launch-readiness]] | Rollout from RFC; metrics from PRD |

**Spec-first is narrower than PRD** — engineering contract for one team sprint, not stakeholder alignment.

Update brief status to **Approved** with date; link spec/ADR in header.

### 7. Keep the brief alive — or supersede

Briefs are **living during Define/Plan**, frozen at **Approved** for that release slice.

When scope or approach changes materially:

- **Update** brief with changelog section, or
- **Supersede** with new brief/RFC referencing old ([[decision-docs]] immutability pattern)

Post-ship retrospective: did metrics move? Feed [[idea-shaping]] for v2.

### 8. Scenario playbooks

**New user-facing feature**

Idea-shaping → PRD draft → design review → eng review → approved → spec-first → build.

**Platform migration (no UX)**

RFC with alternatives → spike for risky unknown → approved → migration-path plan → incremental delivery.

**Executive priority drop**

Shape problem in 1-pager → PRD scope minimal v1 → explicit out-of-scope → fast review with named approver.

**Cross-team API initiative**

RFC interfaces first → partner teams comment → contract frozen → PRDs per consumer if needed.

**Customer-driven one-off**

Evidence it's representative segment → PRD or explicit "custom exception" with sunset → decision-doc.

**PRD without eng review**

Risk: unbuildable scope — always include eng reviewer for feasibility and dependencies.

**RFC without product context**

Risk: solves technical elegance not user outcome — link PRD or problem statement.

**Brief after code started**

Retrospective doc only — mark as retrospective; don't call it alignment.

## Common Rationalizations

- "Everyone already agrees." — Writing it down discovers they don't.
- "A doc slows us down." — Less than building wrong thing or reversing in sprint 4.
- "We'll align as we go." — Mid-build disagreement is the most expensive kind.
- "Skip alternatives in RFC." — Reviewers can't trust the choice without them.
- "PRD is PM only." — Eng, design, support input prevents surprise scope.
- "Open questions we'll solve in implementation." — Blockers stay blockers; name owners now.
- "Success metric is obvious." — Obvious metrics get measured differently by each team.
- "RFC is too technical for a brief." — That's why RFC exists separately from PRD.

## Red Flags

- Cross-cutting work with no shared written plan
- PRD lists solutions but vague problem or metric
- RFC single option, no alternatives or trade-offs
- Open questions open when coding starts
- Brief written after ship to rationalize
- Success metrics without baseline or measurement plan
- No named approver — "the team" approved
- Scope out section empty — creep guaranteed
- RFC ignores migration, security, or rollback
- PRD requirements not testable ("intuitive", "modern")
- Stakeholder never read doc — approval theater
- Brief and spec contradict — no single source of truth

## Verification

- [ ] Right artifact chosen — PRD, RFC, or both; idea shaped if needed ([[idea-shaping]])
- [ ] Problem, audience, evidence — not solution-only narrative
- [ ] Goals with measurable success + guardrails; scope in/out explicit
- [ ] Requirements prioritized and testable (PRD)
- [ ] Design, alternatives, trade-offs, rollout documented (RFC)
- [ ] Dependencies, risks, open questions with owners and dates
- [ ] Structured review completed; approval recorded with date
- [ ] No implementation on unresolved blockers
- [ ] Handoff to [[spec-first]] / [[work-planning]] / [[decision-docs]] clear
- [ ] Brief status updated; supersede path if approach changes
