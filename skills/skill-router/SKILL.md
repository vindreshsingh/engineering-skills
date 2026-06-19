---
name: skill-router
description: Meta-skill that routes a task to the right engineering skill. Load this at the start of a session — it maps what you're about to do to the skill that should govern how you do it.
---

# Skill Router

This repo's skills are step-by-step processes, not reference docs. The hard part is loading the right
one at the right moment. Use the map below: identify what you're doing, load the matching skill, and
follow it. When several apply, work top-down through the lifecycle.

## How to Route

Match the task to a skill by intent:

| You're about to… | Load |
|------------------|------|
| Shape a raw idea into something concrete | [[idea-shaping]] |
| Write a PRD / product brief | [[product-brief]] |
| Define what to build before coding | [[spec-first]] |
| Break work into ordered tasks | [[work-planning]] |
| Implement a feature or change | [[incremental-delivery]] + [[test-first]] |
| Decide what to put in an agent's context | [[context-curation]] |
| Rely on an API/library's real behavior | [[source-first]] |
| Build or change user-facing UI | [[ui-craft]] |
| Make UI usable by everyone (a11y) | [[accessibility]] |
| Turn a design into code | [[design-handoff]] |
| Make React/Next.js fast | [[react-patterns]] |
| Design an API/module/schema boundary | [[interface-design]] |
| Design a database schema or fix queries | [[data-modeling]] |
| Build an AI/LLM-powered feature | [[llm-feature-engineering]] |
| Make code correct under failure (timeouts, retries) | [[resilience]] |
| Verify a web change in the browser | [[browser-checks]] |
| Debug a failure or unexpected behavior | [[fault-recovery]] |
| Review a change before merge | [[review-gate]] |
| Clean up / refactor for clarity | [[simplify]] |
| Handle untrusted input, auth, secrets | [[hardening]] |
| Fix something slow | [[perf-budget]] |
| Add caching to an expensive read | [[caching-strategy]] |
| Add or upgrade a dependency | [[dependency-hygiene]] |
| Commit, branch, merge, recover in git | [[git-flow]] |
| Set up or fix CI/CD | [[pipeline-ops]] |
| Change a schema/API/dependency others use | [[migration-path]] |
| Record a decision or fix docs | [[decision-docs]] |
| Ship to production | [[launch-readiness]] |
| Add logging, metrics, tracing, alerts | [[observability]] |
| Handle a production incident or postmortem | [[incident-response]] |
| Write or improve a skill in this repo | [[skill-creator]] |

## Lifecycle Order

When a task spans phases, move through them rather than jumping to code:

**Define** → **Plan** → **Build** → **Verify** → **Review** → **Ship** → **Operate**

- Define: idea-shaping, product-brief, spec-first
- Plan: work-planning
- Build: incremental-delivery, test-first, context-curation, source-first, ui-craft, accessibility, react-patterns, interface-design, design-handoff, resilience, data-modeling, caching-strategy, llm-feature-engineering
- Verify: browser-checks, fault-recovery
- Review: review-gate, simplify, hardening, perf-budget, dependency-hygiene
- Ship: git-flow, pipeline-ops, migration-path, decision-docs, launch-readiness
- Operate: observability, incident-response
- Meta: skill-router, skill-creator

## Rules of Use

1. **If a skill matches the task, load and follow it** — don't improvise a worse version of a process
   that already exists.
2. **Follow it fully.** These skills encode the steps people skip under pressure; partial application
   loses most of the value.
3. **Don't load everything at once.** Pull in the skill for the current step; this keeps context lean
   (see [[context-curation]]).
4. **Chain naturally.** Finishing one phase points you at the next.

## When No Skill Fits

If the task genuinely doesn't match anything here, proceed with normal good engineering judgment — and
if it's a recurring kind of work, that's a sign a new skill should be written for it.
