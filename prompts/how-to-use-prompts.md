# How to Use Agent Prompts

Copy-paste prompts for all 27 agents live in [`prompts/agents/`](agents/). Each file is
self-contained — open it, fill the placeholders, copy the block, paste into Cursor, Claude Code,
Copilot, or any agent that reads Markdown instructions.

## Quick start (3 steps)

1. **Pick the agent** — browse [agents/README.md](agents/README.md) or [agent-org.md](../docs/agent-org.md)
2. **Open its prompt file** — e.g. `prompts/agents/sdlc/backend-developer.md`
3. **Copy the prompt block** — replace `[BRACKETS]`, paste into your AI chat

## Example

For a new API endpoint:

1. `product-manager` → write PRD and acceptance criteria
2. `solution-architect` → HLD and API boundaries
3. `team-lead` → task breakdown
4. `backend-developer` → implement (use its copy-paste prompt with the PRD + HLD as `[INPUTS]`)
5. `code-reviewer` → review the diff

## Setup for best results

Point your agent at this repo (clone it, add to workspace, or paste file paths). The prompt references
files like `agents/sdlc/backend-developer.md` and `skills/incremental-delivery/SKILL.md` — the AI needs
access to read them.

**Minimal setup in Cursor:** add `AGENTS.md` or this repo's skills to your project rules, then paste
the agent prompt.

**In Claude Code:** the plugin loads skills automatically; paste the prompt and the agent will follow
the referenced files.

## Do not skip

- **Fill every placeholder** — empty `[INPUTS]` produces vague output
- **Paste real artifacts** — PRD, diff, schema, logs; not summaries of summaries
- **One agent, one task** — "build the whole feature" belongs on `team-lead`, not `backend-developer`
- **Verify outputs** — each skill has a Verification checklist; ask the agent to show it checked

## Prompt structure reference

See [prompt-structure.md](prompt-structure.md) for the anatomy of every prompt file.

## Not sure which agent?

Use the `skill-router` skill (`skills/skill-router/SKILL.md`) or start with `business-analyst` (vague
idea) or `product-manager` (known feature goal).
