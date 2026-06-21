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

This makes all **50 skills**, **38 agents** (30 SDLC + 8 marketing), and session hooks available in
that project. See [docs/plugin-discovery.md](docs/plugin-discovery.md) for load paths.

## Use with any other agent

**Works with** Claude Code, Gemini CLI, Cursor, GitHub Copilot, and any AGENTS.md-aware tool (Codex,
OpenCode, Factory…) — the repo ships the entry-point file each one reads, all pointing at the same
skills.

Skills are plain Markdown. Clone the repo and point your agent at `skills/<name>/SKILL.md`:

```bash
git clone https://github.com/vindreshsingh/engineering-skills.git
```

Per-tool install and usage: [`docs/platforms.md`](docs/platforms.md). General guide:
[`docs/getting-started.md`](docs/getting-started.md).

## Skills by phase

| Phase   | Skills |
|---------|--------|
| Define  | `spec-first`, `product-brief`, `idea-shaping` |
| Plan    | `work-planning`, `product-grooming` |
| Build   | `incremental-delivery`, `test-first`, `ui-craft`, `ux-design`, `accessibility`, `react-patterns`, `mobile-patterns`, `interface-design`, `design-handoff`, `resilience`, `data-modeling`, `caching-strategy`, `llm-feature-engineering`, `i18n-l10n` |
| Verify  | `browser-checks`, `e2e-testing`, `fault-recovery` |
| Review  | `review-gate`, `simplify`, `hardening`, `perf-budget`, `dependency-hygiene` |
| Ship    | `git-flow`, `pipeline-ops`, `migration-path`, `decision-docs`, `technical-writing`, `launch-readiness` |
| Operate | `observability`, `incident-response`, `finops-budget` |
| Grow    | `skills/marketing/*` — see [marketing/README.md](marketing/README.md) |
| Meta    | `agent-guardrails` (always on), `skill-router`, `skill-creator` |

See [SKILLS.md](SKILLS.md) for the full auto-generated catalog. **End-to-end example:**
[docs/sdlc-walkthrough.md](docs/sdlc-walkthrough.md).

## Agent personas

Three general reviewer personas:

- `code-reviewer` — five-dimension review (correctness, readability, architecture, security, performance)
- `security-auditor` — vulnerability detection, threat modeling, secure-coding review
- `test-engineer` — test strategy, test writing, coverage analysis

Plus a full **25-role SDLC org** spanning 8 layers and a **5-role growth team** (Layer 9) for
marketing — positioning, content, social, SEO, and community. See [docs/agent-org.md](docs/agent-org.md)
for the org map and how work flows between roles.

## Repository layout

```
skills/           → Engineering skills (marketing under skills/marketing/)
agents/sdlc/      → SDLC personas (30 agents)
agents/marketing/ → Growth team (8 agents)
marketing/        → Marketing team guide, router, references
hooks/            → Session lifecycle hooks (skill router auto-loaded on session start)
references/       → Engineering checklists (testing, performance, security, accessibility, + phase checklists)
docs/             → Per-tool setup guides
.claude-plugin/   → Plugin + marketplace manifests
```

## Marketing team

A separate **Growth & Marketing** team for post-launch growth — grouped under `marketing/`:

- [marketing/README.md](marketing/README.md) — team guide and flow
- [agents/marketing/](agents/marketing/) — 5 agents (growth-lead, content-marketer, etc.)
- [skills/marketing/](skills/marketing/) — 5 skills (growth-strategy, content-marketing, etc.)
- [prompts/agents/marketing/](prompts/agents/marketing/) — copy-paste prompts

## SDLC team

- [agents/sdlc/README.md](agents/sdlc/README.md) — 30 agents including `ux-designer`, `technical-writer`

## Authoring new skills

Follow [`docs/skill-anatomy.md`](docs/skill-anatomy.md). Every skill needs YAML frontmatter with
`name` + `description`, and the sections: Overview, When to Use, Process, Common Rationalizations,
Red Flags, Verification.

## License

MIT — see [LICENSE](LICENSE).
