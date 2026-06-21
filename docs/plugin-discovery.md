# Plugin Discovery — Nested Skills & Agents

Each skill and agent lives in **one place**. No symlinks.

## Layout

| Team | Path |
|------|------|
| Engineering skills | `skills/<name>/SKILL.md` |
| Marketing skills | `skills/marketing/<name>/SKILL.md` |
| SDLC agents | `agents/sdlc/<name>.md` |
| Marketing agents | `agents/marketing/<name>.md` |

## plugin.json

```json
"skills": ["./skills", "./skills/marketing"],
"agents": ["./agents/sdlc", "./agents/marketing"]
```

## Load in Cursor or Claude Code

```text
agents/sdlc/backend-developer.md
agents/marketing/growth-lead.md
skills/spec-first/SKILL.md
skills/marketing/seo-growth/SKILL.md
```
