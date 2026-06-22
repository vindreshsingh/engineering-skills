# Changelog

All notable changes to this project are documented here. This project adheres to
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- **Three structural-gap skills — security, validation, and release control.** Filling holes that had
  an agent but no process skill:
  - **`threat-modeling` + `/threat-model`** — design-time security: model the system and trust
    boundaries, enumerate threats systematically (STRIDE), rate by likelihood × impact, and record a
    response for every one (mitigate/eliminate/transfer/accept). Sits between `agent-guardrails`
    (runtime) and `hardening` (code review); gives the `security-architect` agent a process.
  - **`experimentation` + `/experiment`** — valid A/B testing: a falsifiable hypothesis, one primary
    metric plus guardrails, a pre-computed sample size, correct randomization, and an honest readout
    (no peeking, confidence intervals, "no effect" is a result). Closes the discover→build→measure
    loop; homes the `product-analyst` agent's experiment work.
  - **`feature-flags` + `/flag`** — decouple deploy from release: typed flags, safe defaults, both
    paths tested, single-seam gating, gradual rollout with a tested kill switch, a flag registry, and
    mandatory removal after rollout. Pairs with `launch-readiness` and `experimentation`.

  All three ship with commands and behavioral tests (coverage stays 100%) and are wired into
  `skill-router` (classify signals, Plan/Verify/Ship maps, lifecycle, and disambiguation vs
  `hardening`/`agent-guardrails`, `test-first`/`observability`, and `launch-readiness`/`migration-path`).
- **`agent-memory` + `/agent-memory`.** Completes the Operate-Autonomously cluster with durable
  cross-session agent memory: persist only high-signal facts (no secrets, run state, or one-offs), keep
  memory separate from single-run state, scope each memory to a context/identity with governed
  read/write, retrieve by relevance instead of dumping the store, write structured attributed memories,
  and govern drift/poisoning (don't over-generalize, re-verify remembered facts against reality, gate
  writes, curate by update/merge/prune). Wired into `skill-router` (Meta/Operate-Autonomously map,
  lifecycle, disambiguation vs `context-curation` / `long-running-agents` / `skill-harvest`) with a
  behavioral test (coverage stays 100%).
- **Operate-Autonomously cluster — running agents in loops and over long horizons.** Three new skills
  closing the gap that the "loop engineering" / "long-running agents" body of work describes:
  - **`autonomous-loops` + `/autoloop`** — design & supervise a self-prompting loop accountably:
    verifiable stop condition, maker/checker split, isolation + PR integration, iteration/time/token
    circuit breakers, a triage inbox for decisions the loop must not make, and the human as verifier
    (guards against comprehension debt and cognitive surrender).
  - **`long-running-agents` + `/longrun`** — keep an agent coherent across hours/days: external plan +
    progress files, commit-based checkpoints, deliberate context compaction/handoff to fight context
    rot and alignment drift, tested state reconstitution, and a planner/worker/judge split for fleets.
  - **`agent-verification` + `/agent-verify`** — stop premature "done": separate generation from
    evaluation with an independent (ideally different-model) checker, run rather than read, enforce a
    test ratchet, catch early termination, and re-verify at handoff boundaries.

  All three ship with commands and behavioral tests (coverage stays 100%) and are wired into
  `skill-router` (Meta/Operate-Autonomously map, classify signals, lifecycle, an autonomous-run recipe,
  and disambiguation vs `orchestrated-delivery` / `review-gate` / `test-first`).
- **GTM launch pipeline (`launch-campaign`) + `/launch`.** New Grow-phase conductor that turns a
  shipped feature into a complete launch kit — positioning, seeded community, SEO landing, launch
  content, a per-platform social post pack, email and referral loops, and a measurement plan — by
  running the marketing persona team (`growth-lead` → `community-manager` → `seo-strategist` →
  `content-marketer` → `social-media-manager` → `email-marketer`/`referral-manager` → weekly review)
  in order, gating on the community-before-traffic rule. Ships with the `/launch` command and a
  behavioral test, and is wired into `skill-router` (Grow map, lifecycle, launch recipe, disambiguation
  vs `launch-readiness` / `growth-strategy`) and the marketing router. Completes the
  **discover → build → launch** arc; distinct from `/ship` (`launch-readiness`, the engineering gate).
- **PM discovery pipeline (`product-discovery`) + `/discover`.** New discovery conductor that turns a
  one-line idea into a decision-ready package — validated problem, PRD with scope and acceptance
  criteria, primary success metric, RFC handoff decision, and an ordered task breakdown — by running
  the PM persona trio (`business-analyst` → `product-manager` → `product-analyst` → `team-lead`)
  through the Define and Plan phases with sign-off gates. Ships with the `/discover` command and a
  behavioral test, and is wired into `skill-router` (Define map, lifecycle, a discovery recipe, and
  disambiguation vs `idea-shaping` / `product-brief` / `orchestrated-delivery`). This is the
  "discover" bookend the code-only competitors lack.
- **Self-improving skill loop (`skill-harvest`) + `/harvest`.** New meta-skill that captures a hard-won
  lesson from the current session back into the library before context is lost — triaging it (new skill /
  improve existing / guardrail / router fix / doc / drop) and handing keepers to `skill-creator`. Ships
  with a `/harvest` command and a behavioral test, is wired into `skill-router` (Meta map, lifecycle
  table, disambiguation vs `skill-creator`, and the bug-fix recipe), and the session-start hook now
  nudges a harvest pass after non-trivial work. This closes the loop so the library compounds over time.

## [1.5.0] - 2026-06-21

Highlights: behavioral skill testing at **100% coverage** (CI-enforced), enforced skill invocation, an
**orchestrated build loop** (`orchestrated-delivery` + `parallel-subagents`), **multi-platform** entry
points (Gemini, Cursor, Copilot, Codex/OpenCode), and a full launch kit with an end-to-end demo.

### Added
- **End-to-end demo + submission kit.** `docs/launch/demo-walkthrough.md` shows the 40-role org
  shipping "Add Product Reviews" phase by phase (with a Mermaid flow diagram), linked from the README;
  `docs/launch/submissions.md` has copy-paste marketplace + awesome-list submission text.
- **Behavioral test coverage reached 100%** — every one of the 52 process skills now has a
  pressure-scenario test (meta routers excluded). Added the remaining 24 tests across engineering and
  marketing skills; `scripts/skill-test.sh` excludes meta skills from the coverage denominator.
- **Launch kit + discovery.** Repo description and topics set for GitHub discovery; README hero with
  badges and an honest comparison; a `docs/launch/` go-to-market kit (positioning, announcement post,
  Show HN / X / LinkedIn copy, SEO plan) drafted with the repo's own marketing skills.
- **Behavioral test coverage crossed 50%** (28/53). Added pressure-scenario tests for work-planning,
  incremental-delivery, source-first, context-curation, interface-design, caching-strategy,
  dependency-hygiene, git-flow, pipeline-ops, launch-readiness, observability, decision-docs,
  accessibility, and browser-checks.
- **Multi-platform entry points.** Ships the instruction file each major agent reads — `GEMINI.md`
  (Gemini CLI), `.cursor/rules/engineering-skills.mdc` (Cursor), `.github/copilot-instructions.md`
  (Copilot) — plus `AGENTS.md` for Codex/OpenCode/Factory and the existing Claude Code plugin. All
  delegate to `skill-router` as the single source of truth. Per-tool guide in `docs/platforms.md`.
- **Orchestrated delivery (the build loop).** New flagship skill `orchestrated-delivery` — a conductor
  that drives a feature end-to-end (define → plan → build → verify → review → ship), loading the
  governing skill and persona at each phase, gating on exit criteria + sign-off, and dispatching
  independent work to parallel subagents. Supporting skill `parallel-subagents` for the dispatch
  technique, a `/deliver` command, and behavioral tests for both. Turns the persona org into a
  coordinated system rather than a roster.
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
