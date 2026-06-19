# Changelog

All notable changes to this project are documented here. This project adheres to
[Semantic Versioning](https://semver.org/).

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
