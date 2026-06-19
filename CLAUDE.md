# engineering-skills

A collection of engineering skills for AI coding agents, packaged as a Claude Code plugin. This file
guides work **on this repository itself** (authoring and maintaining skills).

## Structure

```
skills/         → One SKILL.md per skill (the processes)
agents/         → Reviewer personas (code-reviewer, security-auditor, test-engineer)
commands/       → Slash commands (/spec, /plan, /build, /test, /review, /ship)
hooks/          → Session lifecycle hooks (skill-router injected on session start)
references/     → Supplementary checklists (testing, performance, security, accessibility)
docs/           → Getting-started and skill-authoring guides
.claude-plugin/ → Plugin + marketplace manifests
```

## Skills by phase

- **Define:** idea-shaping, product-brief, spec-first
- **Plan:** work-planning
- **Build:** incremental-delivery, test-first, context-curation, source-first, ui-craft,
  react-patterns, interface-design, design-handoff, resilience, data-modeling, llm-feature-engineering
- **Verify:** browser-checks, fault-recovery
- **Review:** review-gate, simplify, hardening, perf-budget
- **Ship:** git-flow, pipeline-ops, migration-path, decision-docs, launch-readiness
- **Operate:** observability, incident-response
- **Meta:** skill-router

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
