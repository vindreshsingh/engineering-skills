# Submissions — ready to copy-paste

Get listed where people already look. Each listing is an indexed inbound link **and** an install
surface. These are drafted; you submit them (each needs your GitHub action to open the PR / form).

## 1. Claude Code plugin marketplace

The repo is already a valid marketplace (`.claude-plugin/marketplace.json`). To get into a public
marketplace listing:

- **Self-serve (works today):** anyone installs via
  `````text
  /plugin marketplace add vindreshsingh/engineering-skills
  /plugin install engineering-skills@engineering-skills
  `````
  Put exactly this in your README (already there) and every post.
- **Community marketplaces:** open a PR adding your plugin to a community marketplace repo (e.g. an
  `obra/superpowers-marketplace`-style list) — search GitHub topic `claude-code-plugin` for active ones.
- **Official marketplace:** follow Anthropic's current submission process for the official plugin
  marketplace; ensure `plugin.json` has `name`, `description`, `version`, `homepage`, `repository`,
  `license` (it does).

**Pre-submit checklist:** ✅ valid manifests, ✅ LICENSE (MIT), ✅ README with install + screenshots,
✅ CI green, ✅ semver tags/releases.

## 2. awesome-* list entry (copy-paste)

Open a PR to `awesome-claude-code`, `awesome-ai-coding`, `awesome-cursor`, etc. with:

```markdown
- [engineering-skills](https://github.com/vindreshsingh/engineering-skills) — 53 behaviorally-tested
  engineering skills + a 40-role SDLC & marketing org + an orchestrated build loop. Works with Claude
  Code, Cursor, Gemini, Copilot, and Codex.
```

Keep it one line, factual, no hype — that's what gets merged.

## 3. Product directories (optional)

- **Product Hunt** — schedule a launch; lead with "an engineering team for your coding agent".
- **GitHub topics** — already set; they drive topic-browse traffic.

## Order of operations (highest leverage first)

1. README install block + a screenshot/the demo diagram (done — `demo-walkthrough.md`).
2. Show HN (`social.md`) — the install audience.
3. awesome-list PRs (above) — durable inbound links.
4. Marketplace listing PR.
5. Announcement post + X/LinkedIn threads.

Track referrers in GitHub Insights weekly; double down on what sends installs.
