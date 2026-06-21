---
name: decision-docs
description: Captures architectural decisions and the reasoning behind them (ADRs) and keeps docs useful. Use when making a significant technical choice, recording what an RFC or experiment decided, when documentation is missing, stale, or misleading, or when future maintainers will ask "why not X?"
---

# Decision Docs

Code shows what you did. It cannot show what you considered and rejected, which constraint forced your
hand, or why a workaround exists. That context decays fast — six months later, even you won't remember,
and the next person will relitigate a settled question or repeat a mistake you already made.

Decision docs capture **why** at the moment of choice. They are cheap to write when the reasoning is
fresh; they are expensive to reconstruct from git history and Slack.

This skill covers **ADRs** (immutable decision history), **living docs** (updated as the system changes),
and **pointers** (short rules that link to the full record). Pair with [[product-brief]] when a RFC
produces a decided approach, [[spec-first]] for requirements that precede design choices,
[[migration-path]] when a decision implies a staged rollout, [[context-curation]] for where durable
"why" should live in agent memory, and [[launch-readiness]] when shipping needs a changelog and
communicated risks.

## When to Use

- Choosing an architecture, framework, datastore, protocol, auth model, or major pattern
- A trade-off future maintainers will question ("why not Postgres?", "why this cache TTL?")
- A decision that's costly to undo or touches many modules, teams, or deployments
- An RFC or experiment concluded — record what was decided and what was rejected
- A workaround, hack, or "temporary" fix that will outlive the sprint
- Documentation is absent, outdated, or describes a system that no longer exists
- Compliance or audit needs a traceable record of why data is handled a certain way
- The same debate keeps resurfacing in PRs or standups

Skip for trivial choices with no lasting cost — local variable names, one-off scripts, reversible edits
with no architectural impact. Don't ADR everything; reserve records for decisions that **stick**.

## Process

Work in order. Not every situation needs a full ADR — step 1 decides the right artifact.

### 1. Decide what kind of record you need

| Situation | Artifact | Mutable? |
|-----------|----------|----------|
| Significant, hard-to-reverse technical choice | **ADR** | Supersede only — never edit in place |
| How the system works today (setup, architecture overview) | **Living doc** (`README`, `docs/`) | Update as code changes |
| Short rule agents/devs see every session | **Pointer** in `CLAUDE.md` / rules | Update when ADR superseded |
| Experiment or A/B concluded | **Decision note** (ADR or experiment log entry) | Immutable once decided |
| Operational "how to" under failure | **Runbook** | Update when procedure changes |
| Incident revealed a systemic gap | **Postmortem** + ADR if architecture changes ([[incident-response]]) |

**Write an ADR when** reversing the choice would require a migration, affect multiple services, or
change a public contract. **Skip an ADR when** the choice is local, easily reversible, and obvious from
the code.

### 2. Write at decision time — not after shipping

Capture the record while alternatives and constraints are still in your head. After shipping, memory
compresses to "we chose X" and loses the rejected options.

Minimum timing:

- **Before merge** for choices embedded in the PR (new datastore, new auth flow).
- **At RFC approval** for approaches reviewed in [[product-brief]].
- **When adding a workaround** — label it temporary in the ADR with an expiry or follow-up task.

If you discover you shipped without recording: write the ADR now, note it's retrospective, and capture
what you still remember of the alternatives.

### 3. Structure an ADR

Keep ADRs short — one to two pages. Long ADRs aren't read.

```markdown
# ADR-NNN: [Short title in domain language]

- **Status:** Proposed | Accepted | Deprecated | Superseded by ADR-XXX
- **Date:** YYYY-MM-DD
- **Deciders:** [names or roles]

## Context

What problem or constraint forces a choice? Link to ticket, RFC, incident, or metric.
State facts, not opinions — "p95 checkout latency is 800ms" not "checkout is slow."

## Decision

What we will do — one clear statement. Not a design doc; the choice.

## Options considered

| Option | Pros | Cons | Why not |
|--------|------|------|---------|
| A — … | … | … | … |
| B — … | … | … | **Chosen** / rejected because … |

The rejected options and **why they lost** are the highest-value section. Reviewers and future readers
trust the decision when they see what was weighed.

## Consequences

**Positive:** what we gain.
**Negative:** what we give up — cost, complexity, operational burden, consistency limits.
**Follow-ups:** migrations, monitoring, tech debt tickets, review date for "temporary" choices.

## References

Links to RFC, spike code, benchmark results, compliance requirement.
```

For product or experiment decisions, the same shape works — replace "architecture" with "product
choice" and link success metrics from the brief.

### 4. Lead with constraints, then the choice

Readers ask "why this?" before "what is it?" Order matters:

1. **Problem and constraints** — latency budget, team skill, regulatory rule, existing stack.
2. **Decision** — the choice, stated plainly.
3. **Alternatives** — what else was on the table.
4. **Trade-offs** — what the choice costs.

A decision without named trade-offs reads like marketing. Every real choice gives something up —
latency for consistency, simplicity for flexibility, cost for speed. Name it.

### 5. Keep records close to the code

Decision docs belong in version control, beside what they describe:

- `docs/adr/0001-use-event-sourcing.md` or `doc/architecture/decisions/`
- Number sequentially; zero-pad (`0001`) for sort order
- Link ADRs from the relevant `README`, module doc, or architecture overview
- **Never** only in wiki/Confluence/Notion without a repo link — those drift and disappear

For pointers in standing agent memory ([[context-curation]]):

```markdown
<!-- Good: short rule + link -->
API errors use `ApiError` in `lib/errors.ts` — see ADR-012 (no raw string throws).

<!-- Bad: full ADR pasted into CLAUDE.md -->
```

### 6. Treat ADRs as immutable history

Once **Accepted**, do not edit the body to reflect new reality. The ADR is a record of what was decided
**then**.

When the decision changes:

1. Write a **new ADR** with the new choice.
2. Set old ADR status to **Superseded by ADR-XXX**.
3. Update living docs and pointers to reference the new ADR.
4. Execute the migration ([[migration-path]]) — code, data, and docs move together.

Editing old ADRs hides evolution and makes audits unreliable. Superseding preserves the trail.

### 7. Document what code cannot say

**Write in ADRs and living docs:**

- Why a workaround exists and when to remove it
- Non-obvious setup steps ("needs this env var because…")
- Dragons — race conditions, ordering assumptions, "never call X before Y"
- Rejected approaches that might look tempting later
- Ownership boundaries between services or modules
- Retention, PII, and compliance constraints ([[hardening]], [[data-modeling]])

**Do not write:**

- Narration of what the code already shows (`getUser` fetches the user)
- Copy-pasted function signatures that live in types
- Docs that duplicate a skill's process — link the skill instead

**Code comments** are for local non-obvious mechanics at the line level. **ADRs** are for choices that
span files and years. Don't put a novel in a comment; don't put line logic in an ADR.

### 8. Maintain living docs — prune stale ones

Living docs (`README`, `docs/architecture.md`, setup guides) describe **current state**. Unlike ADRs,
they **must be updated** when the system changes.

When you touch an area:

- If the doc describes behavior that no longer exists → **fix or delete** it
- If a section is wrong → fix it in the same PR as the code change
- If nobody knows if it's true → verify against code ([[source-first]]) then fix
- If the doc repeats an ADR → shorten to a pointer

**Wrong docs are worse than none.** They send people down rabbit holes. A missing doc prompts questions;
a wrong doc prompts confident mistakes.

Audit triggers:

- Onboarding feedback ("the docs said X but…")
- Repeated questions in PRs about the same topic
- A major migration or deprecation shipped without doc updates

### 9. Link decisions into the workflow

Decisions should be findable when they matter:

| Moment | Action |
|--------|--------|
| **PR** | Link ADR in description for architectural changes; reviewer checks consequences |
| **RFC approval** | Accepted RFC → ADR or ADR extracted from RFC alternatives section |
| **Launch** | Changelog + user-facing docs updated ([[launch-readiness]]) |
| **Incident** | Postmortem action items → ADR if architecture must change |
| **Deprecation** | ADR or living doc states replacement and timeline ([[migration-path]]) |
| **Compliance review** | ADR references control requirement and data-handling rationale |

### 10. Scenario playbooks

**Tech selection (database, queue, framework)**

- Spike or benchmark if options are close; put numbers in the ADR.
- Document operational cost — not just dev ergonomics.
- Record who maintains it and what happens at 10× scale.

**Temporary workaround**

- ADR with **Status: Accepted (temporary)** and a review date or removal ticket.
- Code comment points to ADR number.
- If the workaround survives two review dates, either promote it to intentional design or fund the fix.

**RFC → shipped decision**

- RFC is the discussion artifact; ADR is the compact outcome.
- Don't let the RFC be the only record — RFCs are long and get stale.

**Recurring "why not X?" in PRs**

- Write or resurrect the ADR; link it in the PR template or module README.
- Close the debate with documented trade-offs, not repeated opinions.

**Experiment / product choice**

- Record: hypothesis, metric, result, decision (ship / don't ship / iterate).
- Link from [[product-brief]] success metrics.

**Compliance and audit**

- ADR states which requirement drove the design (retention period, encryption, access model).
- Enough for an auditor to trace **requirement → decision → implementation** without reading code.

**Onboarding a new area**

- Living doc: current architecture diagram + pointers to key ADRs.
- New hire reads current state first, then ADRs for history — not the reverse.

## Common Rationalizations

- "The code is self-documenting." — Code documents *what*, never the *why* or the roads not taken.
- "I'll remember why." — You won't, and the next person never knew.
- "Docs always go stale." — ADRs are dated history that stays valid; living docs get updated in the same PR as code.
- "It's obvious." — Obvious to you today, with all the context you're about to forget.
- "We discussed it in the RFC/meeting." — Discussion artifacts are long and unsearchable; extract the decision.
- "ADR overhead for a small choice." — Skip the ADR for small choices; don't skip recording significant ones.
- "I'll add a comment in the PR." — PRs merge and disappear; ADRs persist and link.
- "Wiki is fine." — Wiki without repo links drifts; version-controlled docs travel with the code.
- "We'll update the docs later." — Later never comes; wrong docs ship alongside wrong assumptions.

## Red Flags

- A major architectural choice with no record of why
- The same debate resurfacing every quarter — no ADR to settle it
- Docs describe a version of the system that no longer exists
- Editing past ADRs in place instead of superseding
- Comments/docs that restate the code instead of explaining intent
- Workarounds with no ticket, no ADR, and no review date
- RFC approved but no compact decision record extracted
- `CLAUDE.md` or rules bloated with full decision prose instead of pointers
- Compliance-sensitive handling with no traceable rationale
- Changelog or user docs missing for a user-visible decision ([[launch-readiness]])
- Postmortem action "fix architecture" with no ADR or migration plan

## Verification

- [ ] Significance assessed — ADR for sticky choices; skipped for trivial reversible edits
- [ ] Record written at decision time (or retrospective ADR with noted gaps)
- [ ] ADR has context, decision, options considered, consequences, and references
- [ ] Rejected alternatives and trade-offs explicit — not only the chosen path
- [ ] ADR lives in version control with sequential numbering; linked from README or module docs
- [ ] Old ADRs superseded, not edited, when decisions change
- [ ] Living docs updated in the same PR as behavioral code changes
- [ ] Stale or wrong docs fixed or removed — not left to mislead
- [ ] Workarounds have ADR or ticket with review/removal date; code points to record
- [ ] Pointers in agent memory are short and link to ADRs ([[context-curation]])
- [ ] RFC/experiment outcomes captured in a durable decision record
- [ ] Launch changelog and user-facing docs updated when the decision is user-visible
- [ ] Compliance or audit-sensitive choices traceable to requirement and implementation
