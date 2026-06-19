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

If you load nothing else, start with these three — they close the biggest quality gaps:

1. `spec-first` — decide what to build before building it.
2. `test-first` — prove it works.
3. `review-gate` — check correctness and safety before merge.

## Full lifecycle

Load skills by phase as the work moves through them:

```
Define   → idea-shaping, product-brief, spec-first
Plan     → work-planning
Build    → incremental-delivery, test-first, ui-craft, react-patterns, interface-design,
           design-handoff, resilience, data-modeling, llm-feature-engineering
Verify   → browser-checks, fault-recovery
Review   → review-gate, simplify, hardening, perf-budget
Ship     → git-flow, pipeline-ops, migration-path, decision-docs, launch-readiness
Operate  → observability, incident-response
```

Don't load everything at once — it wastes context. Pull in the skill for the current step (see the
`context-curation` skill).

## Using the agents

`agents/` holds reviewer personas (code-reviewer, security-auditor, test-engineer). Load one when you
want a focused pass: "Review this diff using the code-reviewer persona."

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

## Using the references

`references/` holds supplementary checklists — testing patterns, and performance, security, and
accessibility checklists — to use alongside the related skill.

## Writing your own skills

Follow [skill-anatomy.md](skill-anatomy.md). Keep skills general, actionable, and tight.
