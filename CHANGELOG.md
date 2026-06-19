# Changelog

All notable changes to this project are documented here. This project adheres to
[Semantic Versioning](https://semver.org/).

## [1.2.0] - 2026-06-19

### Added
- A 25-role SDLC agent org across 8 layers (product/business, architecture, engineering management,
  development, quality, DevOps/platform, governance, release) — 24 new persona files in `agents/`, each
  wired to the skills it drives, plus `docs/agent-org.md` mapping layers, outputs, and handoffs.
- Plugin manifest now loads all agents from the `agents/` directory.

## [1.1.0] - 2026-06-19

### Added
- Four skills (33 total): `caching-strategy`, `dependency-hygiene`, `accessibility` (promoted from the
  reference checklist into a process skill), and `skill-creator` (a dogfooded meta-skill for authoring
  skills). Routing, lifecycle, and indexes updated accordingly.

## [1.0.0] - 2026-06-19

### Added
- 29 engineering skills covering the full lifecycle (define, plan, build, verify, review, ship), each
  an executable process with verification criteria.
- New runtime and AI-app skills: `observability`, `resilience`, `incident-response`, `data-modeling`,
  `llm-feature-engineering`.
- Three reviewer agent personas: `code-reviewer`, `security-auditor`, `test-engineer`.
- Slash commands: `/spec`, `/plan`, `/build`, `/test`, `/review`, `/ship`, `/idea`, `/secure`,
  `/perf`, `/debug`, `/simplify`.
- Reference checklists: testing patterns, performance, security, accessibility.
- Claude Code plugin packaging (`.claude-plugin/`) and a session-start hook that loads the skill router.
- `scripts/validate.sh` (structure/frontmatter/manifest checks) and `scripts/generate-catalog.sh`
  (regenerates `SKILLS.md`), enforced by CI.
- Contributor guide and authoring docs.
