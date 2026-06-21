# Getting Started

These skills work with any AI coding agent that reads Markdown instructions. This guide covers the
universal approach; the Claude Code plugin install is in the top-level [README](../README.md).

## What a skill is

Each skill is a `SKILL.md` describing a specific engineering workflow — the steps, the verification,
the anti-patterns, and the exit criteria. When an agent loads a skill, it follows that process.

**Skills are processes, not reference docs.** The value is in doing the steps, including the ones
people skip when rushed.

## Quick start with any agent

1. **Get the skills.**
   ```bash
   git clone https://github.com/vindreshsingh/engineering-skills.git
   ```
2. **Pick the skill** for your task — browse `skills/`, or use `skills/skill-router/SKILL.md`, which
   maps task types to the right skill.
3. **Load it into your agent.** Paste the `SKILL.md` content into the system prompt, add it to your
   rules file (`CLAUDE.md`, `.cursorrules`, etc.), or reference it in conversation: "Follow the
   test-first process for this change."
4. **Let it drive.** The agent works through the skill's steps and verification rather than improvising.

## Recommended minimal setup

If you load nothing else, start with these four — they close the biggest quality and safety gaps:

0. `agent-guardrails` — never delete data, read secrets, or break security without explicit approval.
1. `spec-first` — decide what to build before building it.
2. `test-first` — prove it works.
3. `review-gate` — check correctness and safety before merge.

## Full lifecycle

Load skills by phase as the work moves through them:

```
Define   → idea-shaping, product-brief, spec-first
Plan     → work-planning
Build    → incremental-delivery, test-first, ui-craft, accessibility, react-patterns,
           interface-design, design-handoff, resilience, data-modeling, caching-strategy,
           llm-feature-engineering
Verify   → browser-checks, fault-recovery
Review   → review-gate, simplify, hardening, perf-budget
Ship     → git-flow, pipeline-ops, migration-path, decision-docs, launch-readiness
Operate  → observability, incident-response
Grow     → skills/marketing/* (see marketing/README.md)
```

Don't load everything at once — it wastes context. Pull in the skill for the current step (see the
`context-curation` skill).

## Marketing team

Post-launch growth uses a **separate marketing team** grouped under `marketing/`:

- Guide: [marketing/README.md](../marketing/README.md)
- Router: [marketing/SKILL.md](../marketing/SKILL.md)
- Agents: [agents/marketing/](../agents/marketing/)
- Prompts: [prompts/agents/marketing/](../prompts/agents/marketing/)

Load paths: [plugin-discovery.md](plugin-discovery.md).

**Full lifecycle example:** [sdlc-walkthrough.md](sdlc-walkthrough.md)

## Using the agents

`agents/sdlc/` holds 30 SDLC role personas plus three focused reviewers (`code-reviewer`,
`security-auditor`, `test-engineer`). Marketing: `agents/marketing/`. See [agent-org.md](agent-org.md).

Load a persona when you want a role's perspective:

```
Act as the backend-developer agent. Follow agents/sdlc/backend-developer.md and prompts/agent-base.md.
```

Each persona lists **primary** and **secondary** skills. It loads `skills/<name>/SKILL.md` and follows
that process — see [prompts/agent-base.md](../prompts/agent-base.md).

**Copy-paste prompts:** [prompts/agents/sdlc/](../prompts/agents/sdlc/) and [prompts/agents/marketing/](../prompts/agents/marketing/)
See [how-to-use-prompts.md](../prompts/how-to-use-prompts.md).

## Using the commands (Claude Code)

`commands/` provides slash commands that load the matching skill:

| Command | Loads |
|---------|-------|
| `/idea` | idea-shaping |
| `/spec` | spec-first |
| `/plan` | work-planning |
| `/build` | incremental-delivery + test-first |
| `/test` | test-first |
| `/debug` | fault-recovery |
| `/review` | review-gate |
| `/simplify` | simplify |
| `/secure` | hardening |
| `/perf` | perf-budget |
| `/ship` | launch-readiness |
| `/groom` | product-grooming |
| `/grow` | marketing router → `skills/marketing/*` |
| `/incident` | incident-response |
| `/migrate` | migration-path |
| `/a11y` | accessibility |
| `/e2e` | e2e-testing |

## Using the references

`references/` holds supplementary checklists — testing, performance, security, accessibility, plus
phase checklists (launch-readiness, git-flow, incident-response, pipeline-ops, migration-path,
work-planning, grooming, e2e, technical-writing).

## Writing your own skills

Follow [skill-anatomy.md](skill-anatomy.md). Keep skills general, actionable, and tight.
