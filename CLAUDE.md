# engineering-skills

A collection of engineering skills for AI coding agents, packaged as a Claude Code plugin. This file
guides work **on this repository itself** (authoring and maintaining skills).

## Structure

```
skills/         → One SKILL.md per skill (marketing under skills/marketing/)
agents/sdlc/      → SDLC personas (marketing under agents/marketing/)
marketing/      → Marketing team guide, router (SKILL.md), references
prompts/        → Copy-paste agent prompts + skill-loading instructions
commands/       → Slash commands (/spec, /plan, /build, /test, /review, /ship)
hooks/          → Session lifecycle hooks (guardrails + skill-router injected on session start)
references/     → Engineering checklists (testing, performance, security, accessibility)
docs/           → Getting-started and skill-authoring guides
.claude-plugin/ → Plugin + marketplace manifests
```

## Skills by phase

- **Define:** idea-shaping, product-brief, spec-first
- **Plan:** work-planning, product-grooming
- **Build:** incremental-delivery, test-first, ux-design, mobile-patterns, i18n-l10n, context-curation,
  source-first, ui-craft, micro-interactions, accessibility, react-patterns, interface-design, design-handoff, resilience,
  data-modeling, caching-strategy, llm-feature-engineering
- **Verify:** browser-checks, e2e-testing, fault-recovery
- **Review:** review-gate, simplify, hardening, perf-budget, dependency-hygiene, version-upgrade
- **Ship:** git-flow, pipeline-ops, migration-path, decision-docs, technical-writing, launch-readiness
- **Operate:** observability, incident-response, finops-budget
- **Grow:** `skills/marketing/` — growth-strategy, content-marketing, social-distribution, seo-growth,
  community-engagement (team guide: `marketing/`)
- **Meta:** agent-guardrails (always on), skill-router, skill-creator

## Conventions

- A skill lives in `skills/<name>/SKILL.md`; the directory name equals the frontmatter `name`.
- Frontmatter has `name` and `description`; the description says what the skill does, then when to
  use it.
- Every skill has: overview, When to Use, Process, Common Rationalizations, Red Flags, Verification.
- Supporting files only when a section truly exceeds ~100 lines; otherwise fold it in.
- Link related skills with `[[name]]`. Don't duplicate content across skills — reference instead.
- Full format spec: [docs/skill-anatomy.md](docs/skill-anatomy.md).

## Validating a change

- Every `SKILL.md` has valid YAML frontmatter with `name` and `description`.
- Each directory name matches its skill's `name`.
- Plugin manifests in `.claude-plugin/` remain valid JSON.

## Boundaries

- **Always** follow the skill-anatomy format for new or edited skills.
- **Never** add a skill that's vague advice instead of an actionable process.
- **Never** duplicate prose between skills — link to the other skill.
