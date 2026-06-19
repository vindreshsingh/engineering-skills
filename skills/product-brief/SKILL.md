---
name: product-brief
description: Writes a product brief / PRD or a technical RFC that aligns people before building. Use when a feature needs shared understanding across stakeholders, or a technical approach needs review before commitment.
---

# Product Brief

A brief exists to get people aligned *before* the work starts — what we're building and why (PRD), or
how we propose to build it (RFC). Its job is to surface disagreement early, while it's cheap, and to
give everyone one source of truth.

## When to Use

- A feature or initiative needs sign-off or shared understanding across people/teams
- A significant technical approach should be reviewed before you commit to it
- Multiple stakeholders have a stake in the what or the how
- You need a durable record of the plan and the reasoning

## Process

**For a product brief / PRD (the *what* and *why*):**
1. **Problem & audience** — the user pain and who has it, grounded in evidence, not assertion.
2. **Goals & success metrics** — what changes if this works, measured how.
3. **Scope** — what's in, and explicitly what's out for this round.
4. **Requirements** — the user-facing behaviors, prioritized (must vs. later).
5. **Risks, dependencies, open questions** — with owners.

**For a technical RFC (the *how*):**
1. **Context & problem** — constraints, current state, why now.
2. **Proposed approach** — the design, key components, data/contracts.
3. **Alternatives considered** — and why they lost (the most useful section for reviewers).
4. **Trade-offs & impact** — performance, security, migration, cost, complexity.
5. **Rollout & open questions.**

Then: **circulate for review, capture the discussion, and resolve open questions** before building.
Record the decided approach so it isn't relitigated (see [[decision-docs]]).

## Common Rationalizations

- "Everyone already agrees." — Writing it down is how you discover they don't.
- "A doc slows us down." — Far less than building the wrong thing or reversing a bad design.
- "I'll just start; we'll align as we go." — Mid-build disagreement is the most expensive kind.
- "Skip the alternatives section." — That section is exactly what lets reviewers trust the choice.

## Red Flags

- Building something cross-cutting with no shared written plan
- A PRD full of solutions but vague on the problem or success metric
- An RFC with one option and no alternatives or trade-offs
- Open questions left unresolved when implementation starts
- The brief written *after* the work, to rationalize it

## Verification

- [ ] Problem, audience, and why-now are clear and evidence-backed
- [ ] Goals have measurable success criteria; scope names what's out
- [ ] (RFC) Approach, alternatives, and trade-offs are spelled out
- [ ] Risks, dependencies, and open questions have owners
- [ ] It was reviewed by stakeholders and open questions resolved before building
- [ ] The decided approach is recorded for posterity
