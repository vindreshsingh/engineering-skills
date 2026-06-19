# AGENTS.md

Guidance for AI coding agents (Claude Code, Cursor, Copilot, and others) working in a project that
uses these engineering skills.

## The model

This repository is a set of **skills** — step-by-step engineering processes in `skills/<name>/SKILL.md`.
The operating principle is simple: when a task matches a skill, load that skill and follow it fully,
rather than improvising a weaker version of a process that already exists.

Core rules:

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
- UI work → `ui-craft`; accessibility → `accessibility`; design to code → `design-handoff`; React/Next perf → `react-patterns`
- Verify a web change → `browser-checks`
- Security / untrusted input / auth → `hardening`
- Something slow → `perf-budget`; caching → `caching-strategy`
- Failure handling (timeouts, retries, idempotency) → `resilience`
- Database schema / queries → `data-modeling`
- Building an AI/LLM feature → `llm-feature-engineering`
- Adding / upgrading dependencies → `dependency-hygiene`
- Writing or improving a skill in this repo → `skill-creator`
- Logging, metrics, tracing, alerts → `observability`
- A production outage / postmortem → `incident-response`
- Git work → `git-flow`; CI/CD → `pipeline-ops`
- Changing something others depend on → `migration-path`
- Decisions / docs → `decision-docs`
- Shipping to production → `launch-readiness`
- Not sure which applies → `skill-router` (the routing meta-skill)

## Lifecycle

Most non-trivial work moves through phases — don't jump straight to code:

**Define → Plan → Build → Verify → Review → Ship → Operate**

## Agents and references

- `agents/` — reviewer personas (code-reviewer, security-auditor, test-engineer) for focused passes.
- `references/` — checklists (testing, performance, security, accessibility) to use with the matching
  skill.

## For other tools

The skills are plain Markdown and tool-agnostic. Point your agent at the relevant `SKILL.md` via its
system prompt, rules file, or conversation. See [docs/getting-started.md](docs/getting-started.md).
