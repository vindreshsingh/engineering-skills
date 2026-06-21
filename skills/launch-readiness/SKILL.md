---
name: launch-readiness
description: Verifies a change is truly ready to ship — rollout plan, monitoring, rollback, and communication. Use before deploying or releasing to production, cutting a release, or expanding rollout to more users.
---

# Launch Readiness

"Done coding" is not "ready to ship." Before a change reaches users, confirm you can **release it
safely**, **see if it breaks**, **undo it fast**, and **tell people what changed**. The riskier the
change, the more this matters — a silent 100% deploy with no rollback is a bet, not a release.

Launch readiness is the **go/no-go gate** at the Ship phase. It chains verification from Build and
Review into production safely — not a substitute for [[browser-checks]], [[review-gate]], or
[[pipeline-ops]], but the layer that asks "what happens when this hits real traffic?"

Pairs with [[migration-path]] for deploy order and data rollback limits, [[observability]] for signals
before and after, [[git-flow]] for tags and hotfix branches, [[incident-response]] if launch degrades
prod, [[hardening]] for security-sensitive launches, and [[decision-docs]] / changelog for communicated
changes.

## When to Use

- Before deploying a feature, fix, migration, or config change to **production**
- Expanding rollout — canary → 10% → 50% → 100%
- Cutting a release tag or promoting a build to users
- Anything **user-visible**, **hard to reverse**, or on a **critical path** (auth, payments, checkout)
- Setting up launch conventions for a team
- Go/no-go meeting before a scheduled release window

**Light pass** for low-risk changes (copy tweak behind flag, internal-only tool). **Full pass** for
data migrations, payment flows, auth, and large audience flips.

Skip only for changes with zero production surface (local tooling) — rare for this skill.

## Process

Work in order. Don't deploy until rollback and observability are in place for the risk level.

### 1. Classify risk — depth of readiness follows risk

| Tier | Examples | Readiness depth |
|------|----------|-----------------|
| **Low** | Copy, CSS behind flag, internal admin | CI green, quick smoke, owner watching |
| **Medium** | New UI flow, new API field, perf change | Staging verify, metrics, rollback tested, gradual rollout |
| **High** | Migration, payments, auth, deletion, scale change | Full checklist, canary, exec comms, soak, on-call engaged |

Under-preparing a high-tier launch causes incidents; over-preparing every typo wastes time — classify
first.

### 2. Confirm it works where it will run

Production differs from your laptop. Before go:

- [ ] **CI green** on the release commit ([[pipeline-ops]])
- [ ] **Merged PR reviewed** ([[review-gate]]); security pass if needed ([[hardening]])
- [ ] **Staging / preview** — same **commit** or artifact you'll promote, not an older build
- [ ] **Production-like data** where it matters — large accounts, edge locales, legacy rows
- [ ] **Config & secrets** — env vars, feature flags, API keys in target environment (not just code)
- [ ] **Dependencies** — migrations applied, third-party keys live, queues/topics exist
- [ ] **UI** — [[browser-checks]] on staging at prod config; critical paths exercised

**Staging passed** is necessary, not sufficient — scale, cache, and data shape differ in prod.

### 3. Plan deploy order — sequence matters

Wrong order breaks deploys mid-flight ([[migration-path]]):

```text
Typical safe order:
1. Expand DB/schema (backward-compatible migration)
2. Deploy backend that tolerates old + new schema
3. Backfill data (batched, monitored) if needed
4. Deploy frontend / enable flag for new behavior
5. Contract phase later — remove old path when usage zero
```

Document **dependencies**: "API v2 before mobile app 2.1", "migration 0042 before app deploy."

**Maintenance window** only when unavoidable — document start/end and rollback trigger.

### 4. Plan the rollout — gradual beats instant

Prefer **contained exposure** over flipping everyone at once:

| Strategy | When | Control |
|----------|------|---------|
| **Feature flag** | New behavior toggleable | Off → internal → % → 100% |
| **Canary** | Infra supports traffic split | 1% → 5% → 25% → 100% |
| **Staged regions** | Multi-region deploy | Region A → B → all |
| **Dark launch** | Code in prod, behavior off | Validate metrics at zero traffic |
| **Blue/green** | Instant switch with two pools | Switch + rollback = switch back |

Define **steps and pauses**:

```text
10:00 — deploy build + flag OFF (dark)
10:15 — enable internal dogfood (flag: staff)
11:00 — 5% users, watch 30 min
12:00 — 50% if metrics green
14:00 — 100% or halt
```

**Who watches** each step — name a person, not "the team."

No flag/canary available for high-tier change → smaller audience first (beta group, single tenant)
or explicit risk acceptance documented.

### 5. Rollback — tested, documented, data-aware

Rollback is not "we'll revert git." Define **exact undo** for each layer:

| Layer | Rollback action | Data reversible? |
|-------|-----------------|------------------|
| Feature flag | Turn OFF | Usually yes |
| App deploy | Redeploy previous artifact / revert commit | Code yes |
| Config | Restore previous config version | Usually yes |
| **DB migration** | Often **not** trivial — plan expand-contract ([[migration-path]]) |
| Cache | Purge or TTL wait | May serve stale briefly |

**Test rollback before launch** in staging:

- Deploy new → verify → rollback → verify old behavior restored
- If migration can't roll back, **forward-fix plan** is mandatory — not optional hope

Document in release notes:

```text
Rollback: flip `checkout_v2` flag OFF + redeploy v1.4.2 if needed.
Migration 0042 is expand-only — rollback does NOT remove column.
```

### 6. Observability before launch — not after

You must **know** if the launch broke something ([[observability]]):

**Define healthy** for this change:

```text
Checkout v2 launch:
- p95 POST /orders latency < 500ms
- error rate on /orders < 0.5%
- conversion rate within 5% of baseline (business metric)
```

**Before go-live:**

- [ ] Metrics emitted for new code paths — counters, latency histograms
- [ ] Dashboard panel or saved query for launch signals
- [ ] **Alerts** on symptom thresholds — error spike, latency SLO, queue depth
- [ ] Logs structured with correlation id; no secrets ([[hardening]])
- [ ] **Trigger test** — force an error in staging; confirm alert fires (or would fire)

**During launch:** same dashboard open; don't discover gaps when users complain.

### 7. Go / no-go criteria

Explicit **hold** conditions — anyone can call halt:

```text
GO if:
- CI green, staging sign-off, rollback tested
- On-call aware, dashboard ready
- No open blocker bugs

NO-GO if:
- Unresolved migration risk
- Rollback untested
- Missing alerts on critical path
- Key person unavailable with no backup
```

Scheduled release with NO-GO → **postpone**, don't "YOLO" because the calendar says Tuesday.

### 8. Communicate — internal and external

| Audience | What | When |
|----------|------|------|
| **Engineering / on-call** | What's shipping, rollout steps, rollback commands, dashboard link | Before deploy |
| **Support / CS** | User-visible changes, known issues, macros | Before user exposure |
| **Stakeholders** | Risk tier, window, success metrics | Before / after go |
| **Users** | Changelog, in-app notice, status page if risky | When behavior changes |

**Launch owner** — single name for "is this launch still go?" during the window.

External comms factual — don't promise what isn't shipped yet.

### 9. Watch through rollout — don't deploy and leave

**Active monitoring** through each rollout step:

- Error rate, latency, saturation — compare to **pre-launch baseline**, not zero
- Business metrics lag technical — know the delay (conversion may be T+1h)
- **Soak period** after 100% — 30–60+ min for high tier; watch for cache refill, retry storms
- **Ready to roll back** — IC or launch owner can call it ([[incident-response]])

Checklist after each ramp:

```text
5% ramp: errors flat, p95 +12ms (acceptable), proceed
50% ramp: error spike on payment — HALT, flag OFF, incident declared
```

### 10. Post-launch — close the loop

Within 24–48 hours:

- [ ] Metrics vs success criteria — ship decision validated or learnings captured
- [ ] **Flag cleanup plan** — remove old path after stable ([[migration-path]])
- [ ] **Docs** — user docs, API docs, runbook updated ([[decision-docs]])
- [ ] **Changelog / release notes** published
- [ ] **Retro** if launch was rocky — action items tracked ([[incident-response]])
- [ ] Remove temporary launch dashboards/alerts or tune thresholds for steady state

Launch isn't done at deploy — it's done when stable and documented.

### 11. Scenario playbooks

**Feature behind flag**

Deploy dark → internal ON → staged % → full → remove old path in follow-up PR.

**Database migration + code**

Expand migration deploy → app deploy (dual-read) → backfill job monitored → later contract migration.

**Breaking API change**

New version live alongside old → migrate clients → deprecate old with metrics ([[interface-design]],
[[migration-path]]).

**Payment / checkout change**

High tier: canary, payment test cards in prod monitor, rollback = flag + revert, finance notified.

**Mobile app + server**

Server backward-compatible first → app store release → force-upgrade only if unavoidable.

**Config-only change**

Diff config in staging → deploy → watch dependency that reads config → rollback = previous config rev.

**Hotfix during incident**

Branch from prod tag ([[git-flow]]); minimal fix; accelerated launch with single watcher; postmortem
after ([[incident-response]]).

**Low-risk copy / UI polish**

CI + staging smoke + owner watches deploy — skip full canary if tier is low and flag exists.

## Common Rationalizations

- "It worked in staging." — Prod data, scale, and config differ; verify and watch real traffic.
- "We can roll back if needed." — Only if rollback exists, is tested, and handles data.
- "Add monitoring after launch." — You're blind exactly when it matters most.
- "Just ship to everyone." — Canary/flag turns outage into a blip.
- "Rollback is redeploy — easy." — Migrations and cache often make it hard; test it.
- "Alerts exist somewhere." — Confirm they fire on **this** change's failure mode.
- "Support will figure it out." — Brief them before users hit the change.
- "We'll write release notes after." — Notes before launch clarify what you're risking.
- "Go/no-go is bureaucracy." — Five minutes prevents multi-hour incidents.

## Red Flags

- Deploy straight to 100% with no flag, canary, or beta cohort (high/medium tier)
- Rollback never tested; migration with no forward-fix plan
- No metrics/alerts on the changed code path before traffic hits it
- Deploy and walk away — nobody watching dashboard during ramp
- Config/secrets differ between staging and prod untracked
- Deploy order wrong — code before backward-compatible migration
- Release notes / support brief missing for user-visible change
- "Healthy" undefined — no way to know if launch succeeded
- Forced deploy because of calendar despite open NO-GO criteria
- Rollback plan is "fix forward" only with no time estimate
- Launch owner unnamed; on-call unaware
- Post-launch flag and dead code never cleaned up

## Verification

- [ ] Risk tier classified; readiness depth matches
- [ ] CI green; staging verified on **release artifact**; config/secrets confirmed ([[pipeline-ops]], [[browser-checks]])
- [ ] Deploy order documented; migrations expand-before-code ([[migration-path]])
- [ ] Rollout steps defined — flag/canary/%, pauses, watchers named
- [ ] Rollback tested — code, flag, config; data limits documented
- [ ] Healthy signals defined; metrics, dashboard, alerts live and tested ([[observability]])
- [ ] Go/no-go criteria explicit; launch owner assigned
- [ ] Support/stakeholders briefed; changelog/release notes ready ([[decision-docs]])
- [ ] Active watch through ramp + soak; halt criteria enforced
- [ ] Post-launch: metrics vs success criteria; docs updated; cleanup planned
