# Platforms

engineering-skills is **tool-agnostic** — the skills, agents, and router are plain Markdown. Most
coding agents read a project instructions file (`AGENTS.md` is the cross-tool standard); this repo
ships the entry-point file each major tool expects, all pointing at the same skills.

| Tool | Entry point in this repo | Notes |
|------|--------------------------|-------|
| **Claude Code** | `.claude-plugin/` + `CLAUDE.md` | Installable as a plugin (below) |
| **Gemini CLI** | `GEMINI.md` | Loaded at session start |
| **Cursor** | `.cursor/rules/engineering-skills.mdc` | Project rule, `alwaysApply` |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Repo custom instructions |
| **Codex / OpenCode / Factory / others** | `AGENTS.md` | These read `AGENTS.md` natively |

## Claude Code (plugin)

```text
/plugin marketplace add vindreshsingh/engineering-skills
/plugin install engineering-skills@engineering-skills
```

Or declaratively in a project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "engineering-skills": { "source": { "source": "github", "repo": "vindreshsingh/engineering-skills" } }
  },
  "enabledPlugins": { "engineering-skills@engineering-skills": true }
}
```

## Gemini CLI

Place the repo (or its contents) where Gemini reads project context; `GEMINI.md` is loaded
automatically and points the agent at the router and skills.

## Cursor

`.cursor/rules/engineering-skills.mdc` is picked up as a project rule (`alwaysApply: true`). Open the
repo as a project, or copy the rule into your own project's `.cursor/rules/`.

## GitHub Copilot

`.github/copilot-instructions.md` is read as repository custom instructions when the repo is open.

## Codex / OpenCode / Factory / any AGENTS.md-aware tool

These tools read `AGENTS.md` from the project root automatically — no extra setup. It states the
invocation rule and points at `skills/skill-router/SKILL.md`.

## Any other agent (manual)

1. Clone the repo: `git clone https://github.com/vindreshsingh/engineering-skills.git`
2. Add `AGENTS.md` (or the relevant `SKILL.md`) to your agent's system prompt / rules file.
3. Use `skills/skill-router/SKILL.md` to pick the skill for the task, then follow it.

## Using across runtimes

Several runtimes (Codex, Copilot CLI, Gemini CLI) also recognize a shared `~/.agents/skills/`
directory. To make these skills available everywhere, symlink them there:

```bash
mkdir -p ~/.agents/skills
ln -s "$(pwd)/skills/"* ~/.agents/skills/
```
