# engineering-skills — Gemini CLI

Gemini CLI loads this file at session start. The skills, agents, and routing live in tool-agnostic
Markdown; this file points Gemini at them.

## The rule

If there is even a ~1% chance a skill applies to what you're about to do, **consult the skill router
and follow the matching skill before acting** — before clarifying questions, before code. Partial
application counts as skipping. The user's explicit instructions always take precedence.

## How to use the skills

- **Router:** read [`skills/skill-router/SKILL.md`](skills/skill-router/SKILL.md) to map the task to a
  skill, then follow that skill's `SKILL.md` step by step.
- **Whole feature?** use [`skills/orchestrated-delivery/SKILL.md`](skills/orchestrated-delivery/SKILL.md)
  to run define → plan → build → verify → review → ship.
- **Personas:** `agents/sdlc/` and `agents/marketing/` hold role personas; each drives the relevant skills.
- **Full guidance:** see [AGENTS.md](AGENTS.md).

Skills are processes to follow, not reference docs.
