---
name: feature-flags
description: Decouples deploy from release using feature flags — ship code dark, roll out gradually, kill instantly, and remove the flag once it's done. Use when releasing risky or large changes, rolling out by percentage/cohort, delivering A/B variants, or when stale flags are accumulating as debt.
---

# Feature Flags

Deploying code and releasing a feature are different events, and conflating them is why launches are
scary. A feature flag separates them: merge and deploy the code **dark**, then turn it on for 1%, a
cohort, or everyone — and turn it **off in seconds** if it misbehaves, with no rollback deploy. The
power comes with a cost: every flag is a branch in your runtime and a line of debt. This skill is how to
get the control without drowning in permanent conditional spaghetti.

It's the delivery mechanism the rest of the lifecycle leans on: [[incremental-delivery]] merges work
behind a flag, [[experimentation]] uses flags to split variants, and [[launch-readiness]] uses them for
gradual rollout and instant kill. Pair with [[observability]] (watch the metric as you ramp) and
[[simplify]] (remove the flag when done).

## When to Use

- Releasing a **risky or large change** you want to deploy before exposing
- **Gradual rollout** — percentage ramp, internal-first, beta cohort, region by region
- Delivering **A/B / experiment variants** cleanly ([[experimentation]])
- Needing a **kill switch** for a dependency-heavy or failure-prone path
- **Trunk-based development** — merging incomplete work safely behind a flag
- Stale flags are piling up and need a **cleanup pass**

**Skip** when a change is trivial and safe to ship directly — a flag adds a code path to test and remove;
don't flag a typo fix. Don't use flags to avoid ever finishing the work either (see debt below).

**Not a substitute for** [[launch-readiness]] (the full release gate) or [[migration-path]] (data/contract
migration) — flags control *exposure*; those govern *readiness* and *schema change*.

## Process

### 1. Classify the flag — its type sets its lifespan
- **Release flag** — hide work-in-progress; **short-lived**, removed once fully rolled out.
- **Ops / kill switch** — disable a risky path under load or failure; **long-lived** but few.
- **Experiment flag** — split variants for [[experimentation]]; removed when the test concludes.
- **Permission / entitlement flag** — gate by plan/role; **permanent** by design, treat as config.

Knowing the type up front tells you when (or whether) it dies. Most pain comes from release flags that
never got removed.

### 2. Name and default safely
Name for intent and direction (`enable_new_checkout`, not `flag2`). **Default to off / the safe path** —
a missing or failed flag lookup must fall back to current behavior, never to the half-built new one.

### 3. Keep the flagged code path testable on both sides
Both states ship in the binary, so both must work. Test **flag-on and flag-off** paths
([[test-first]]); CI should exercise both. Don't let the off-path rot — it's your rollback.

### 4. Minimize blast radius and nesting
- Check the flag at **one clear seam**, not sprinkled through ten files — wrap the entry point.
- **Avoid nested/combinatorial flags** — three interacting booleans is eight untested states. If logic
  depends on flag combinations, you have a state-machine problem, not a flag.
- Evaluate flags **deterministically per user** so a user doesn't flip mid-session ([[experimentation]]
  needs stable assignment).

### 5. Roll out gradually with a metric and a kill plan
Ramp deliberately — internal → 1% → 10% → 50% → 100% — watching the primary and guardrail metrics at
each step ([[observability]]). Define the **kill condition** before ramping (error rate, latency, a
business metric) and confirm the off-switch actually works. A kill switch you've never tested is a hope,
not a control.

### 6. Govern the inventory
Maintain a registry: each flag's **owner**, type, default, created date, and **expected removal**. A
flag with no owner is a future incident. Stale release flags are tech debt with a security and
correctness cost (dead code paths, surprising states).

### 7. Remove the flag — this is part of the job, not optional
Once a release flag is at 100% and stable, **delete it and the losing code path** ([[simplify]]). The
task isn't done at full rollout; it's done when the flag is gone. Schedule removal when you create the
flag, not "someday." Permanent flags (entitlement, kill switches) are the only ones that stay.

## Common Rationalizations

- "I'll remove the flag later." — "Later" is how a codebase ends up with 200 dead flags; schedule removal when you add it.
- "Just check the flag wherever I need it." — Scattered checks are untestable and unremovable; gate at one seam.
- "The off-path won't be used, skip testing it." — The off-path is your rollback; if it's broken you can't kill the feature.
- "A few nested flags are fine." — N flags = 2^N states; nobody tests them all. Collapse to explicit states.
- "Default it on so people see the new thing." — A failed lookup then serves half-built code; default to the safe path.
- "Flags let us skip the release gate." — Flags control exposure, not readiness; [[launch-readiness]] still applies.

## Red Flags

- Release flags with no owner or removal date in any registry
- The same flag checked in many scattered places
- Nested/combinatorial flags creating untested state combinations
- Flag defaults to the new/unsafe behavior on lookup failure
- Off-path (rollback) untested or rotted
- Kill switch never actually exercised
- Flags used as permanent forks instead of being removed after rollout
- 100%-rolled-out flags still in the code months later

## Verification

- [ ] Flag type classified (release / ops / experiment / permission) with a matching lifespan
- [ ] Named for intent; defaults to the safe/current path on missing-or-failed lookup
- [ ] Both flag-on and flag-off paths tested in CI ([[test-first]])
- [ ] Evaluated at one clear seam; no nested/combinatorial flag logic; stable per-user assignment
- [ ] Gradual rollout plan with primary + guardrail metrics and a pre-defined, tested kill condition
- [ ] Registry entry: owner, type, default, created and expected-removal dates
- [ ] Release/experiment flags removed (with dead path) after rollout/conclusion ([[simplify]])
