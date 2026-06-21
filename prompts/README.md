# Prompts

Copy-paste prompts and shared instructions for agent personas.

| File / folder | Purpose |
|---------------|---------|
| [how-to-use-prompts.md](how-to-use-prompts.md) | **Start here** — 3-step guide for end users |
| [prompt-structure.md](prompt-structure.md) | Anatomy of every agent prompt (sections, placeholders) |
| [agent-base.md](agent-base.md) | How every persona loads and follows `skills/<name>/SKILL.md` |
| [agents/sdlc/](agents/sdlc/) | **30 SDLC prompts** — [index](agents/sdlc/README.md) |
| [agents/marketing/](agents/marketing/) | **8 marketing prompts** — [index](agents/marketing/README.md) |

## Quick start

1. Open [agents/README.md](agents/README.md) or [agents/sdlc/README.md](agents/sdlc/README.md) and pick your agent
2. Open that agent's prompt file (e.g. `prompts/agents/sdlc/backend-developer.md`)
3. Fill `[BRACKETS]` in the copy-paste block and paste into Cursor, Claude Code, or any AI agent

Personas in `agents/` reference `prompts/agent-base.md`. End-user prompts in `prompts/agents/` tell the
AI which persona and skill files to load for great results.
