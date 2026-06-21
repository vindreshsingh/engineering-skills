---
name: version-upgrade
description: Researches and executes a safe third-party package upgrade from current to target version. Use when bumping any dependency — run web search and read official release notes, migration guides, and changelogs to list new features, breaking changes, and step-by-step fixes before editing the lockfile.
---

# Version Upgrade

Upgrading a package without research is how **green CI and broken production** happen. The target version
may rename APIs, drop Node support, change defaults, or break peers you didn't know you had.

This skill is the **research → impact → fix → verify** loop for one package (or a tight group) at a
time. Search the web and read official docs **before** changing versions — don't guess from semver alone.

Pairs with [[dependency-hygiene]] for vetting and cadence, [[migration-path]] when the upgrade breaks
internal or external callers, [[source-first]] to verify APIs against real docs, [[test-first]] and
[[browser-checks]] to prove behavior, [[fault-recovery]] when the upgrade fails mid-way, and
[[decision-docs]] for major framework jumps.

Run the [version upgrade checklist](../../references/version-upgrade-checklist.md) and capture findings
in the PR description.

## When to Use

- Bumping a direct dependency (major, minor, or patch) with unknown impact
- Renovate/Dependabot PR needs human review and migration work
- Framework upgrade (React, Next.js, Vue, Django, Spring, etc.)
- Toolchain upgrade (TypeScript, ESLint, webpack, Vite, Jest, Playwright)
- Peer dependency conflicts after `npm install` / `pnpm install`
- "Latest version" requested — need features list and breaking change plan first

**Skip** as primary skill for adding a **brand-new** dependency (use [[dependency-hygiene]] vetting).
**Not a substitute for** [[migration-path]] when **your** API/schema changes — version-upgrade is for
**vendor** release notes and code fixes in **your** repo.

| Situation | Lead skill |
|-----------|------------|
| Should we add this package? | [[dependency-hygiene]] |
| Upgrade React 18 → 19, Next 14 → 15 | **version-upgrade** |
| Our REST API v1 → v2 for consumers | [[migration-path]] |
| CVE patch, same major | **version-upgrade** (lighter pass) |

## Process

One package (or one logical stack) per branch. Do not upgrade unrelated deps in the same PR.

### 1. Lock the upgrade scope

Record before any search:

| Field | Example |
|-------|---------|
| Package | `next` |
| Ecosystem | npm / pnpm / yarn / pip / cargo / go / maven / nuget |
| **Current** resolved version | `14.2.3` (from lockfile, not range) |
| **Target** version | `15.1.0` |
| Reason | features, CVE, EOL, peer requirement |

Read the **lockfile** for the resolved version — `package.json` ranges lie.

### 2. Research — web search and official docs (mandatory)

**Do not skip this step.** Use web search and fetch official sources until you have concrete notes.

Search queries (adapt to package):

```text
{package} {current} to {target} migration guide
{package} {target} release notes breaking changes
{package} {target} changelog
{package} upgrade guide site:github.com OR site:{official-docs-domain}
```

**Sources to read (in priority order):**

1. Official **migration guide** / **upgrade guide** for the major jump
2. **GitHub Releases** or **CHANGELOG** for every version between current and target (not only latest)
3. Official documentation — "What's new", deprecation notices, API reference diffs
4. Package registry page — peer dependencies, engines (`node`, `python`), deprecated subpaths
5. Ecosystem blog posts only as **secondary** — verify against official docs ([[source-first]])

**Capture in upgrade notes:**

| Version | New features (relevant to us) | Breaking / behavior changes | Deprecations |
|---------|------------------------------|----------------------------|--------------|
| x.y.z | … | … | … |

If no migration guide exists: read CHANGELOG entry-by-entry from `current+1` through `target`.

### 3. Map breaking changes to this codebase

Inventory **your** usage before editing:

```bash
# Examples — adapt to ecosystem
rg "from ['\"]next" --type ts
rg "require\\(['\"]next" 
grep -r "package-name" . --include="*.ts" --include="*.tsx" --include="*.js"
```

For each breaking change from step 2, mark:

| Breaking change | Affected files / config | Fix strategy | Risk |
|-----------------|-------------------------|--------------|------|
| Removed API `foo()` | `src/lib/bar.ts:12` | Replace with `baz()` per docs | Medium |

Also check:

- **Config files** — `next.config.js`, `vite.config.ts`, `tsconfig`, `eslint.config`, CI workflows
- **Peer dependencies** — other packages that must bump together (upgrade as one group)
- **Transitive breaks** — lockfile may pull new majors of children; scan lock diff
- **Runtime requirements** — Node/Python/Java version bumps → CI and deploy images ([[pipeline-ops]])

If the blast radius is wide or external consumers break, escalate to [[migration-path]].

### 4. Plan the upgrade sequence

Order matters when peers are coupled:

1. **Prerequisites** — runtime (Node 20+), parent framework, shared `@types/*`
2. **Primary package** — bump version in manifest
3. **Peer / plugin packages** — lint, babel, testing library, adapter packages same PR or ordered PRs
4. **Codemods** — run official codemods if documented (`npx @next/codemod`, etc.)
5. **Manual fixes** — file-by-file from breaking change table
6. **Config migration** — renamed options, removed flags, new required fields

Prefer **one logical upgrade PR** when peers must align; split only when bisect needs clear boundaries.

Document **rollback**: previous lockfile hash or git revert path; feature flags if behavior change is risky.

### 5. Execute the bump

```bash
# npm example — use ecosystem equivalent
npm install package@target --save-exact   # or save-dev; prefer lockfile update
npm ci && npm run build && npm test
```

Rules:

- Commit **lockfile** with manifest change ([[dependency-hygiene]])
- Apply codemods **before** manual edits when available
- Fix **compile errors first**, then test failures, then lint
- For each breaking fix, cite **doc section or release note** in PR (link or version heading)
- Don't silence type errors with `any` unless documented temporary — fix the API usage

### 6. Handle common fix patterns

| Change type | Fix approach |
|-------------|--------------|
| Renamed export | Update imports; check subpath exports changed |
| Removed API | Replace per migration guide; don't polyfill vendor internals |
| Changed default behavior | Opt out via config if supported; else update tests and product |
| Stricter types | Fix types at call sites; avoid `@ts-ignore` without ticket |
| Dropped Node/browser version | Update engines, CI, Docker, `.nvmrc` |
| Config key renamed | Map old → new in config; grep for old key in repo |
| Peer dependency warning | Upgrade peer or use supported version matrix from docs |

Re-run web search for **specific error messages** if stuck — include package name and version in query.

### 7. Verify thoroughly

Minimum before merge:

- [ ] Clean install from lockfile in CI (`npm ci`, frozen lock)
- [ ] Build / typecheck passes
- [ ] Unit and integration tests pass
- [ ] Smoke critical user paths ([[browser-checks]] for UI packages)
- [ ] No new high/critical audit issues introduced ([[dependency-hygiene]])
- [ ] Bundle size / startup diff acceptable for front-end ([[perf-budget]] if regressed)
- [ ] Upgrade notes attached to PR — features gained, breaks fixed, config changes

For majors: staged deploy or canary when behavior defaults changed ([[launch-readiness]]).

### 8. Document the outcome

PR description template:

```markdown
## Upgrade: {package} {current} → {target}

### Why
- …

### New features we use (optional)
- …

### Breaking changes addressed
| Change | Fix |
|--------|-----|
| … | … |

### Research links
- [Migration guide](…)
- [Release notes](…)

### Verification
- [ ] CI green on clean install
- [ ] …
```

Major framework upgrades: optional ADR ([[decision-docs]]).

## Common Rationalizations

- "It's just a minor bump." — Minors change behavior; read release notes.
- "Semver says it's safe." — Semver is author intent, not a guarantee; research anyway.
- "Tests will tell us." — Tests miss untested paths and production config; read breaking changes first.
- "We can fix production later." — Upgrade PR is the fix window; don't merge blind.
- "Stack Overflow snippet is enough." — Verify against official docs for **your** version pair.
- "Upgrade everything at once." — One package/group per PR; bisect when something breaks.
- "Lockfile-only PR needs no review." — Hidden transitive majors live in lock diffs.

## Red Flags

- Version bumped with no release notes read
- Web search skipped; only `npm install` and hope
- Multiple unrelated majors in one PR
- Codemod not run when official one exists
- `@ts-expect-error` / `--legacy-peer-deps` without documented reason
- Peer warnings ignored
- Config migration incomplete — old keys still in repo
- CI uses cached node_modules, not clean install
- Breaking default behavior undiscovered until production
- Upgrade notes missing from PR — next person repeats the research

## Verification

- [ ] Current and target versions recorded from lockfile
- [ ] Web search + official migration guide / changelog read for full version range
- [ ] Feature and breaking-change table written for this upgrade
- [ ] Codebase impact mapped (files, config, peers)
- [ ] Upgrade sequence and rollback documented
- [ ] Bump applied with lockfile; codemods run if available
- [ ] All breaking changes fixed with doc-backed approach
- [ ] CI green on clean install; critical paths smoke-tested
- [ ] PR includes research links and breaking-change summary
- [ ] [[migration-path]] invoked if external callers or wide blast radius
