# AGENTS.md

Guidance for AI coding agents (Claude Code, Cursor, Copilot, and others) working in a project that
uses these engineering skills.

## The model

This repository is a set of **skills** — step-by-step engineering processes in `skills/<name>/SKILL.md`.
The operating principle is simple: when a task matches a skill, load that skill and follow it fully,
rather than improvising a weaker version of a process that already exists.

Core rules:

- **Guardrails always on** — load `skills/agent-guardrails/SKILL.md` at session start. Never run
  destructive data operations, read secrets from `.env`/config, or break security controls without
  explicit user approval. See `references/agent-guardrails-checklist.md`.
- If a task matches a skill, use it.
- Follow the skill's steps and verification completely — partial application loses most of the value.
- Load the skill relevant to the current step; don't pull in all of them at once.
- Skills chain: finishing one phase points you to the next.

## Routing intent to a skill

Map what the user is asking for to a skill:

- New feature / functionality → `spec-first` → `work-planning` → `incremental-delivery` + `test-first`
- Vague idea to refine → `idea-shaping`
- PRD or technical RFC → `product-brief`
- Bug / failure / unexpected behavior → `fault-recovery`
- Code review → `review-gate`
- Refactor / cleanup → `simplify`
- API / module / schema boundary → `interface-design`
- UI work → `ui-craft`; motion / click feedback / view transitions → `micro-interactions`; accessibility → `accessibility`; design to code → `design-handoff`; React/Next perf → `react-patterns`
- Verify a web change → `browser-checks`
- Security / untrusted input / auth → `hardening`
- Something slow → `perf-budget`; caching → `caching-strategy`
- Failure handling (timeouts, retries, idempotency) → `resilience`
- Database schema / queries → `data-modeling`
- Building an AI/LLM feature → `llm-feature-engineering`
- Adding / upgrading dependencies → `dependency-hygiene`; upgrading a specific package (research breaking changes) → `version-upgrade`
- Writing or improving a skill in this repo → `skill-creator`
- Logging, metrics, tracing, alerts → `observability`
- A production outage / postmortem → `incident-response`
- Git work → `git-flow`; CI/CD → `pipeline-ops`
- Changing something others depend on → `migration-path`
- Decisions / docs → `decision-docs`
- Shipping to production → `launch-readiness`
- Not sure which applies → `skill-router` (the routing meta-skill)
- Backlog grooming / refinement before sprint → `product-grooming`
- E2E / browser user journey tests → `e2e-testing`
- Internationalization / locales / RTL → `i18n-l10n`
- Mobile app (RN, Flutter, native) → `mobile-patterns`
- UX flows before UI build → `ux-design`
- README, API docs, runbooks → `technical-writing`
- Product launch / go-to-market → `marketing/SKILL.md` (router) → `skills/marketing/growth-strategy`
- SEO / page ranking / organic traffic → `skills/marketing/seo-growth`
- Community engagement / user retention → `skills/marketing/community-engagement`
- Marketing plan / social content / blogs → see `marketing/README.md` and `agents/marketing/`

## Lifecycle

Most non-trivial work moves through phases — don't jump straight to code:

**Define → Plan → Build → Verify → Review → Ship → Operate → Grow**

## Agents and references

- `agents/` — **SDLC** personas in `agents/sdlc/`; **marketing** in `agents/marketing/`. See
  [docs/agent-org.md](docs/agent-org.md), [agents/sdlc/README.md](agents/sdlc/README.md), and
  [marketing/README.md](marketing/README.md).
- `prompts/` — shared instructions for how personas load and follow skills.
- `references/` — checklists (testing, performance, security, accessibility) to use with the matching
  skill.

## For other tools

The skills are plain Markdown and tool-agnostic. Point your agent at the relevant `SKILL.md` via its
system prompt, rules file, or conversation. See [docs/getting-started.md](docs/getting-started.md).
