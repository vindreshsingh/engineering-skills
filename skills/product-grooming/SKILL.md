---
name: product-grooming
description: Runs backlog refinement before sprint planning — clarify stories, split epics, write acceptance criteria, estimate, and confirm Definition of Ready. Use before sprint planning when backlog items need cross-team grooming with Product, Engineering, Architecture, and QA.
---

# Product Grooming

Sprint planning fails when stories are vague. Grooming is the **ceremony** that makes backlog items
dev-ready — user story, testable acceptance criteria, rough estimate, dependencies, and a Ready / Not
ready verdict — before anyone commits capacity.

This skill is the process behind the `product-grooming` agent. It synthesizes team voices; it does
not replace product-manager, architects, or QA.

Pairs with [[spec-first]] for AC quality, [[work-planning]] for estimates and dependencies,
[[idea-shaping]] for still-vague epics, [[product-brief]] when stakeholder alignment is missing, and
[[interface-design]] when API/schema boundaries need early agreement.

## When to Use

- Backlog refinement session before the next sprint
- Epic too large — needs splitting into sprint-sized stories
- Stories lack acceptance criteria or estimates
- Same items keep reappearing ungroomed sprint after sprint
- Cross-team alignment needed (product, eng, arch, QA)

Skip when items are already sprint-ready with AC, estimates, and no blocking questions.

## Process

### 1. Set the session frame

- **Goal:** Which sprint is this grooming for? (usually next)
- **Timebox:** 60–90 minutes; 5–8 stories max
- **Inputs:** Current backlog, PRD/epics, carry-over from last grooming

### 2. Per backlog item — walk team voices

For each epic or story, answer these questions (synthesize; do not guess):

| Voice | Question |
|-------|----------|
| **Product** | Why this? Priority? In/out of scope this sprint? |
| **Business** | Business rules clear? Domain edge cases? |
| **Architecture** | Feasible? Boundaries? Major dependencies? |
| **Team Lead** | Task count? Rough dev days? Blockers? |
| **Eng Manager** | Fits capacity? Calendar realistic? |
| **QA** | AC testable? Happy + unhappy paths? |
| **Security** | PII, authz, abuse? Early red flags? |

Open questions get an **owner and due date** — never assume an answer.

### 3. Clarify and split ([[spec-first]])

- Rewrite: *As a … I want … so that …*
- Add **testable acceptance criteria** per story
- Split if too large — must fit one sprint slice
- Mark **out of scope** explicitly

### 4. Estimate and sequence ([[work-planning]])

- Rough estimate (days or points) with stated assumptions
- Dependencies: schema → API → UI, flags, migrations
- Flag spikes before commitment if unknowns remain

### 5. Definition of Ready gate

**Ready** only when all true:

- [ ] User story + testable AC
- [ ] No blocking open questions (or spike scheduled)
- [ ] Rough estimate with assumptions
- [ ] Dependencies identified
- [ ] Priority confirmed
- [ ] QA confirms AC are testable

Mark each item **Ready** or **Not ready** with what's missing.

### 6. Close the session

- Prioritized list for sprint planning
- Open questions with owners
- Deferred items with reason
- Hand off to scrum-master and engineering-manager

Use [grooming checklist](../../references/grooming-checklist.md) alongside this process.

## Common Rationalizations

- **"We'll figure it out in the sprint"** — Ungroomed stories become mid-sprint surprises.
- **"Only product needs to attend"** — Engineering and QA discover impossibilities late.
- **"Estimates can wait"** — Sprint planning without estimates is guessing.
- **"One big epic is fine"** — Split in grooming, not on day 8.

## Red Flags

- Stories enter sprint planning without AC
- Open questions have no owner
- Estimates without assumptions
- Grooming becomes deep solution design — defer LLD to architects
- Same stories groomed repeatedly with no progress toward Ready

## Verification

- [ ] Every discussed item has Ready / Not ready verdict
- [ ] Ready items have story, AC, estimate, dependencies, priority
- [ ] Not ready items list what's missing and who owns it
- [ ] Session notes captured for sprint planning
- [ ] No story committed with unresolved blocking questions
