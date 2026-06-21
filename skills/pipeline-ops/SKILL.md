---
name: pipeline-ops
description: Designs reliable CI/CD pipelines and build/test/deploy automation. Use when setting up or fixing CI, adding quality gates, configuring deploys, speeding up builds, or stopping flaky checks people ignore.
---

# Pipeline Ops

CI/CD is the **automated gate** every change passes through. It should be **fast**, **deterministic**,
and **trustworthy**: green means safe to merge or ship; red means a real problem. A flaky or 20-minute
pipeline trains people to rerun, bypass, or ignore it — which defeats the entire purpose.

Pipeline ops covers **CI** (verify on every change) and **CD** (promote artifacts to environments).
Build the gate people trust, not the gate they hate.

Pairs with [[git-flow]] for merge requirements, [[dependency-hygiene]] for lockfiles and audit gates,
[[launch-readiness]] for deploy safety nets, [[test-first]] for what tests must run, [[hardening]] for
secrets handling, [[perf-budget]] for optional perf gates, and [[browser-checks]] when E2E runs in CI.

## When to Use

- Setting up CI/CD for a new repo or service
- Adding a quality gate — lint, types, tests, security scan, contract tests
- Pipeline is **slow** — queue times, long feedback loop
- Pipeline is **flaky** — intermittent red builds, retry culture
- People **bypass** CI or merge with red checks
- Configuring or hardening **deploy** to staging/production
- Branch protection and required checks need design
- Workflow/pipeline YAML changes — treat as production code

Skip for one-off local scripts with no automation path. Still pin tools if the script runs in CI.

## Process

Work in order when building or fixing a pipeline.

### 1. Define what the gate must prove

Before YAML, list **what must be true** to merge and to deploy:

| Stage | Typical gates | Blocks |
|-------|---------------|--------|
| **Every PR** | Format, lint, typecheck, unit tests, build | Merge |
| **Every PR** | Dependency audit ([[dependency-hygiene]]) | Merge |
| **PR or main** | Integration tests, contract tests | Merge or main |
| **Pre-deploy** | Staging smoke, E2E critical paths ([[browser-checks]]) | Promote to prod |
| **Optional** | Bundle budget, load test p95 ([[perf-budget]]) | Release train |

**Green must mean something** — if tests don't cover the change, green is false confidence
([[review-gate]]).

Document skipped gates ("no E2E yet") and the risk accepted.

### 2. Stage order — fail fast, fail cheap

Run **fast checks first** so developers get signal in minutes:

```text
1. Format / lint     (~30s)   — catches style and simple errors
2. Typecheck         (~1–2m)
3. Unit tests        (~2–5m)
4. Build             (~2–5m)
5. Integration / E2E (~5–15m)  — parallel where possible
6. Security audit    (~1–3m)   — can parallel with tests
```

Slow jobs **parallelize** — don't run E2E sequentially after a 10-minute integration suite if independent.

**Don't run expensive jobs** on every commit if PR path can use path filters or `main`-only full suite —
but never skip gates on `main` that PRs skipped without policy.

### 3. Determinism — same commit, same result

Non-deterministic CI erodes trust:

- **Pin tool versions** — Node, Python, Go, action versions, linter majors
- **Frozen dependency install** — `npm ci`, lockfile committed ([[dependency-hygiene]], [[git-flow]])
- **Controlled environment** — container image or pinned runner image; document OS packages
- **No network luck** — mock external services in tests; hermetic builds where possible
- **Time and randomness** — fixed seeds in tests; avoid time-of-day flakes

```yaml
# Prefer explicit over floating
node-version: '20.11.0'   # not '20.x' everywhere without lock
```

**Reproduce locally** — `act`, same docker image, or documented `make ci` matching pipeline.

### 4. Kill flakiness — fix tests, don't mask pipeline

A test that passes "usually" is **broken**:

| Wrong | Right |
|-------|-------|
| Auto-retry 3× on all jobs | Fix root cause ([[fault-recovery]]) |
| Ignore flaky suite | Quarantine with ticket + owner + deadline |
| Increase timeout until green | Fix slow/hanging test or infra |
| `sleep(5000)` in E2E | Proper wait on condition |

**Quarantine policy:** flaky test moves to allowed-fail job **only** with linked issue and fix date —
not permanent.

Track **flake rate** — same test failing without code change → priority fix.

E2E flakes often from: timing, test order pollution, shared DB state, live external deps — fix the test
environment ([[test-first]]).

### 5. Speed — cache, parallelize, trim

Slow pipelines get worked around:

- **Dependency cache** — lockfile-keyed; verify cache hit rates
- **Build artifact cache** — compiler caches, incremental builds
- **Parallel jobs** — matrix only when needed; shard large test suites
- **Path filters** — docs-only PR skips mobile build *if* safe and documented
- **Split workflows** — PR fast path vs nightly full sweep
- **Right-sized runners** — CPU for compile-heavy; don't under-provision E2E

Measure **queue + run time** — optimize p95 developer wait, not only job duration.

Target: most PRs get **actionable signal in < 10 minutes** for core gates; longer suites async or parallel.

### 6. Block merge on failure — branch protection

Checks that don't block are suggestions:

- **Required status checks** on `main` — match actual job names
- No admin bypass without policy — bypass culture kills the gate
- **PR required** — no direct push to main ([[git-flow]])
- **Up to date with main** before merge — or merge queue

Red **main** is an emergency — stop the line, fix or revert, don't accumulate broken commits.

Document which checks are **required** vs informational in README or contributing guide.

### 7. Artifacts — build once, promote deploy

**Same artifact** from CI should reach staging and prod — don't rebuild on deploy server from random SHA:

- Build produces **immutable artifact** — container image, bundle, jar — tagged with **git commit**
- Deploy **promotes** tag — staging → prod; rollback = previous tag
- **SBOM / provenance** where policy requires ([[dependency-hygiene]], [[hardening]])

Traceability: deployed prod = image `app:v1.4.2` = commit `abc123` — know what's live
([[incident-response]], [[launch-readiness]]).

### 8. Deploy automation — repeatable with safety net

CD pairs with [[launch-readiness]]:

- **Staging auto-deploy** on main merge — fast feedback
- **Production** — manual approval, release tag, or scheduled train — not accidental every merge
- **Health check** after deploy — HTTP probe, smoke script; fail deploy if unhealthy
- **Rollback** — one command to previous artifact; tested in staging
- **Gradual rollout** — canary/blue-green if platform supports; flags for app logic

**Never** SSH and `git pull` on prod as standard path — undocumented state, no artifact trace.

Deploy scripts and workflow YAML **reviewed in PR** like application code.

### 9. Secrets and credentials — platform, not repo

([[hardening]])

- Secrets in **CI platform vault** — GitHub Secrets, Vault, cloud secret manager
- **Never** in repo, workflow logs, or echo steps
- **Scoped** — staging creds ≠ prod; minimal permissions per job
- **OIDC to cloud** where possible — no long-lived cloud keys in CI
- Rotate on leak; audit secret access

Mask secrets in logs; forbid `set -x` dumping env in debug steps.

### 10. Security and compliance gates

Run in CI, block on policy ([[dependency-hygiene]], [[hardening]]):

- Dependency audit (`npm audit`, OSV, etc.) — fail or warn on critical per policy
- SAST/secret scan on PR — block committed secrets
- Container scan if building images
- License check if enterprise policy requires

Document **exceptions** — suppressed CVE with ticket and expiry, not silent ignore.

### 11. Pipeline config as code

Workflow files live in git:

- **PR review** for pipeline changes — especially deploy steps and secret usage
- **Test workflow changes** — run on a branch before changing required checks on main
- **Version pin** third-party actions — `@v4.2.0` not `@main`
- **CODEOWNERS** on `.github/workflows/` or `ci/` if team policy

Breaking CI on `main` blocks everyone — treat pipeline edits as high-risk.

### 12. Scenario playbooks

**New project CI**

Lint → typecheck → test → build → audit on PR; branch protection; local `make ci` mirror.

**Pipeline suddenly slow**

Profile job timings → cache misses? → new sequential step? → runner queue? → shard or trim.

**Flaky red builds**

Identify flaky test from history → quarantine with issue → fix determinism → un-quarantine.

**Add new required check**

Add job as **non-required** first → stable 1 week → flip required in branch protection.

**Deploy pipeline**

Build image on merge → push to registry → deploy staging auto → prod manual with health check →
rollback doc.

**Monorepo**

Path filters per package; affected-only tests; shared cache keys per lockfile root; don't run entire
matrix on docs PR without policy.

**Hotfix path** ([[git-flow]], [[launch-readiness]])

Branch from prod tag → CI same gates (minimum: test + build) → fast-track review → deploy tagged
artifact → merge back to main.

**E2E in CI** ([[browser-checks]])

Headless browser against staging URL or ephemeral env; artifact screenshots on failure; no flaky
external deps.

**This repo (engineering-skills)**

`scripts/validate.sh` + `generate-catalog.sh` on skill changes ([[skill-creator]]) — schema gate
for content repo pattern.

## Common Rationalizations

- "I'll rerun until green." — Normalizes flake; fix the test or infra.
- "Tests after merge." — Main breaks; everyone blocked; gate on PR.
- "Slow but works." — Slow gets bypassed; optimize or split workflows.
- "Deploy by hand this once." — Manual fails at 2am; automate with rollback.
- "Retries are fine." — Blanket retries hide real failures and slow CI.
- "We'll pin versions later." — Drift breaks CI mysteriously next month.
- "Optional check is enough." — Optional = ignored; required or remove.
- "Secrets in CI vars are fine in the repo backup." — Repo leaks; use platform vault only.

## Red Flags

- Required checks that don't block merge
- Blanket auto-retry on all jobs without flake tracking
- Unpinned actions or tool versions floating
- No lockfile or `npm install` instead of `ci` in pipeline
- Red `main` treated as normal for days
- Secrets in workflow YAML or logged env dumps
- Rebuild prod from source at deploy — no immutable artifact
- Deploy with no health check or rollback tested
- 30+ minute PR feedback with no parallelization plan
- Flaky tests permanently in retry loop
- Pipeline change merged without running the new workflow
- Security audit disabled to green the build
- E2E depends on production third-party services

## Verification

- [ ] Gate goals defined — what merge and deploy must prove
- [ ] Fast checks first; slow jobs parallelized; PR feedback target documented
- [ ] Deterministic — pinned tools, frozen deps, reproducible locally ([[dependency-hygiene]], [[git-flow]])
- [ ] Flaky tests fixed or quarantined with owners — no blanket retry mask
- [ ] Branch protection enforces required checks; red main addressed immediately
- [ ] Immutable artifacts tagged with commit; promote don't rebuild ([[launch-readiness]])
- [ ] Deploy has health check, rollback path, staging before prod
- [ ] Secrets in platform vault; scoped; not in logs ([[hardening]])
- [ ] Security/audit gates run per policy ([[dependency-hygiene]])
- [ ] Pipeline YAML reviewed, versioned, action pins; workflow changes tested
- [ ] Optional: perf/contract/E2E gates documented ([[perf-budget]], [[browser-checks]], [[interface-design]])
