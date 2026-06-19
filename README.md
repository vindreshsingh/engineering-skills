# engineering-skills

A reusable, agent-agnostic collection of **production-grade engineering skills** for AI coding agents
(Claude Code, Cursor, Copilot, Gemini, OpenCode, etc.). Each skill is a step-by-step process — not
reference docs — that an agent follows, including verification steps, anti-patterns, and exit criteria.

Packaged as a **Claude Code plugin marketplace** so you can install it once and use it in any repo.

## Install (Claude Code plugin — use in any repo)

From inside any project, in an interactive `claude` session:

```text
/plugin marketplace add vindreshsingh/engineering-skills
/plugin install engineering-skills@engineering-skills
```

Or wire it into a project declaratively in `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "engineering-skills": {
      "source": { "source": "github", "repo": "vindreshsingh/engineering-skills" }
    }
  },
  "enabledPlugins": {
    "engineering-skills@engineering-skills": true
  }
}
```

This makes all skills, the three agent personas, and the session hooks available in that project.

## Use with any other agent

Skills are plain Markdown. Clone the repo and point your agent at `skills/<name>/SKILL.md`:

```bash
git clone https://github.com/vindreshsingh/engineering-skills.git
```

See [`docs/getting-started.md`](docs/getting-started.md) for per-tool setup.

## Skills by phase

| Phase   | Skills |
|---------|--------|
| Define  | `spec-first`, `product-brief`, `idea-shaping` |
| Plan    | `work-planning` |
| Build   | `incremental-delivery`, `test-first`, `context-curation`, `source-first`, `ui-craft`, `accessibility`, `react-patterns`, `interface-design`, `design-handoff`, `resilience`, `data-modeling`, `caching-strategy`, `llm-feature-engineering` |
| Verify  | `browser-checks`, `fault-recovery` |
| Review  | `review-gate`, `simplify`, `hardening`, `perf-budget`, `dependency-hygiene` |
| Ship    | `git-flow`, `pipeline-ops`, `migration-path`, `decision-docs`, `launch-readiness` |
| Operate | `observability`, `incident-response` |
| Meta    | `skill-router` (routes a task to the right skill), `skill-creator` (author new skills) |

See [SKILLS.md](SKILLS.md) for the full auto-generated catalog with descriptions.

## Agent personas

- `code-reviewer` — five-dimension review (correctness, readability, architecture, security, performance)
- `security-auditor` — vulnerability detection, threat modeling, secure-coding review
- `test-engineer` — test strategy, test writing, coverage analysis

## Repository layout

```
skills/         → One SKILL.md per skill directory
agents/         → Reusable agent personas
hooks/          → Session lifecycle hooks (skill router auto-loaded on session start)
references/     → Supplementary checklists (testing, performance, security, accessibility)
docs/           → Per-tool setup guides
.claude-plugin/ → Plugin + marketplace manifests
```

## Authoring new skills

Follow [`docs/skill-anatomy.md`](docs/skill-anatomy.md). Every skill needs YAML frontmatter with
`name` + `description`, and the sections: Overview, When to Use, Process, Common Rationalizations,
Red Flags, Verification.

## License

MIT — see [LICENSE](LICENSE).
