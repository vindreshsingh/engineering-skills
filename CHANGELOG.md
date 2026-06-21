# Changelog

All notable changes to this project are documented here. This project adheres to
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- **Behavioral skill testing.** Each skill can now have a pressure-scenario test at
  `tests/<skill>.test.md` that proves the skill changes agent behavior (RED → GREEN → REFACTOR), not
  just that it's well-formed. Adds `scripts/skill-test.sh` (structure + coverage), `docs/testing-skills.md`
  (the method), a test template, and exemplar tests for `test-first`, `hardening`, and `simplify`. CI now
  runs the skill-test harness alongside structural validation.
- **Expanded behavioral test coverage** to 12 skills — added pressure-scenario tests for `spec-first`,
  `review-gate`, `resilience`, `data-modeling`, `fault-recovery`, `migration-path`, `incident-response`,
  `llm-feature-engineering`, and `perf-budget`.

### Changed
- **Enforced skill invocation.** The session-start hook and `skill-router` now state a mandatory rule:
  if there's even a ~1% chance a skill applies, invoke it before acting (including before clarifying
  questions or code); partial application counts as skipping. The user's explicit instructions always
  take precedence.

## [1.4.1] - 2026-06-19

### Added
- Skill **`micro-interactions`** — click/tap feedback and React view transitions; checklist in
  `references/micro-interactions-checklist.md`. Wired to frontend-developer, ux-designer, skill-router.
- Skill **`version-upgrade`** — researched package upgrades (web search, release notes, breaking
  changes, fix plan); checklist in `references/version-upgrade-checklist.md`. Wired to
  dependency-analyzer, dependency-hygiene, skill-router.

### Changed
- Removed discovery symlinks — agents and marketing skills live in one path only
  (`agents/sdlc/`, `agents/marketing/`, `skills/marketing/`).
- Deleted `scripts/sync-plugin-symlinks.sh`; plugin uses explicit nested paths.

## [1.4.0] - 2026-06-19

### Added
- **SDLC grouping:** agents moved to `agents/sdlc/`; prompts to `prompts/agents/sdlc/`.
- New skills: `ux-design`, `finops-budget`, `i18n-l10n`, `mobile-patterns` (48 skills total).
- New agents: `ux-designer`, `technical-writer` in `agents/sdlc/`.
- Reference checklists: launch-readiness, git-flow, incident-response, pipeline-ops, migration-path,
  work-planning.
- Slash command `/e2e` for `e2e-testing`.
- Plugin symlinks extended for `agents/sdlc/`; plugin v1.4.0.

### Changed
- `sync-plugin-symlinks.sh` links both SDLC and marketing agents.
- Docs and indexes updated for nested agent paths.

## [1.3.0] - 2026-06-19

### Added
- **Marketing team** (8 skills, 8 agents) grouped under `marketing/`, `skills/marketing/`,
  `agents/marketing/`, with references and copy-paste prompts.
- New engineering skills: `product-grooming`, `e2e-testing`, `technical-writing` (36 engineering total).
- Marketing expansion: `paid-ads`, `email-nurture`, `referral-loop` + 3 agents (8 marketing total).
- **44 skills** total; plugin v1.3.0.
- Slash commands: `/groom`, `/grow`, `/incident`, `/migrate`, `/a11y`, `/observe`.
- `scripts/sync-plugin-symlinks.sh` and [docs/plugin-discovery.md](docs/plugin-discovery.md) for
  Claude Code discovery of nested marketing components.
- [docs/sdlc-walkthrough.md](docs/sdlc-walkthrough.md) — end-to-end feature example.

### Changed
- `plugin.json` v1.3.0 — explicit `skills/marketing` and `agents/marketing` paths.
- README, getting-started, and agent-org updated for Grow phase and marketing team.
- Fixed duplicate agent numbering in agent-org (Development layer 11–14).

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
