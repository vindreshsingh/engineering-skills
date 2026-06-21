# Agent Base — How personas use skills

Every agent persona in `agents/` **drives work through skills** — step-by-step processes in
`skills/<name>/SKILL.md`. Personas define *who you are*, *what you deliver*, and *which skills to
load*. Skills define *how to think and work*. Do not improvise a weaker version of a process that
already exists.

## Guardrails (always on)

**Load first:** `skills/agent-guardrails/SKILL.md` — mandatory for every session and persona.

These guardrails override speed and implicit intent when an action could:

- Delete or truncate data (SQL `DROP`/`TRUNCATE`, unscoped `DELETE`, `rm -rf`, infra teardown)
- Read or exfiltrate secrets (`.env`, credentials, keys, grepping for tokens)
- Break security (disabling hooks/sandbox/auth, force-pushing main, leaking credentials in output)

When a guardrail triggers: **stop**, explain the risk, get **explicit user approval**, or choose a safe
alternative. Checklist: `references/agent-guardrails-checklist.md`.

## Before you start

0. **Load agent guardrails** — read `skills/agent-guardrails/SKILL.md` (or confirm already loaded this session).
1. **Read the persona file** — role, responsibilities, outputs, primary vs. secondary skills.
2. **Load the primary skill** — read `skills/<skill-name>/SKILL.md` in full.
3. **Follow the skill's Process** — execute every step in order. Do not skip or substitute your own
   workflow.
4. **Load secondary skills on demand** — only when the current step or the change touches that area.
   Do not load every listed skill at once (wastes context).
5. **Load references when listed** — `references/<checklist>.md` supplements a skill; use it alongside
   the skill, not instead of it.
6. **Verify before done** — complete the skill's Verification checklist. Outputs are incomplete until
   verification passes.
7. **Chain to the next phase** — when a skill links `[[next-skill]]`, hand off or load that skill for
   the following step.

## Primary vs. secondary skills

- **Primary** — the main process for this persona's typical task. Load first, always.
- **Secondary** — deep dives for specific situations (security in a diff, perf in a schema, etc.).
  Load only when triggered.

## If unsure which skill applies

Load [[skill-router]] (`skills/skill-router/SKILL.md`) and map the user's task to the right skill.

## Output contract

Deliver the persona's **Outputs** in the shape implied by the skills you followed. The persona says
*what* to produce; the skill says *how* to produce it correctly.

## Red flags — stop improvising

- You are giving advice without having loaded a skill's Process.
- You duplicated a skill's steps in your own words instead of following `SKILL.md`.
- You declared an output done without running the skill's Verification checklist.
- You loaded five skills at once before starting work.

When any of these happen, load the primary skill and restart from its Process step 1.
