# engineering-skills — GitHub Copilot

GitHub Copilot reads this file as repository custom instructions.

## The rule

If there's even a ~1% chance a skill applies to the task, **consult the router and follow the matching
skill before acting** — before clarifying questions, before code. Partial application counts as
skipping. The user's explicit instructions always take precedence.

## How to use the skills

- **Router:** `skills/skill-router/SKILL.md` maps the task to the skill that should govern it; then
  follow that skill's `SKILL.md` step by step.
- **Whole feature:** `skills/orchestrated-delivery/SKILL.md` (define → plan → build → verify → review → ship).
- **Personas:** `agents/sdlc/` and `agents/marketing/`.
- **Full guidance:** `AGENTS.md`.

Skills are processes to follow, not reference docs.
