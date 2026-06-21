---
name: incremental-delivery
description: Builds in small, verified increments instead of one big batch. Use when implementing any feature or change — slice vertically, prove each step works, commit at green, then move to the next.
---

# Incremental Delivery

Ship work as a series of **small, working steps**. Each increment compiles, runs, passes its tests,
and could in principle be merged. Big-bang changes hide bugs until the end — when ten moving parts
fail together and [[fault-recovery]] becomes a archaeology project.

Incremental delivery is how you keep **reviewable diffs**, **known-good checkpoints**, and **fast
feedback** on risky ideas. It's not "move slower" — it's fail fast on small surfaces instead of slow
at the finish line.

Default build skill: pair with [[test-first]] to prove each slice, [[work-planning]] to order slices,
[[git-flow]] to commit at green, [[browser-checks]] for UI slices, and [[migration-path]] when each
slice must stay backward-compatible.

## When to Use

- Any implementation beyond a trivial one-line edit
- A feature that would otherwise be a large, hard-to-review PR
- Risky or unfamiliar territory — new API, new datastore, new UI pattern
- Long-running work spanning days or multiple sessions
- Others need to integrate with your branch mid-flight
- AI-generated code that tends toward huge unverified diffs

Skip heavy slicing for truly trivial, isolated fixes (typo, single constant) — still run checks before
push.

## Process

### 1. Plan slices before coding — vertical beats horizontal

Start from [[spec-first]] or [[work-planning]]. List **increments** — each independently demonstrable.

**Vertical slice** (prefer): thin path through all layers that does **one real thing** end-to-end.

```text
Slice 1: POST /orders with one hardcoded SKU → persists row → returns id (no payment)
Slice 2: Validate cart payload + real SKUs from DB
Slice 3: Payment redirect on success
```

**Horizontal slice** (avoid as first increments): whole layer with no user-visible outcome.

```text
Bad first slices: "all models", "all API routes", "all CSS" — nothing works until the end
```

**Walking skeleton / steel thread:** smallest end-to-end path — even ugly — then harden and expand.

| Feature type | First slice example |
|--------------|---------------------|
| API | One endpoint, happy path, real persistence |
| UI page | One section, real data, one state |
| Background job | Process one message type, log success |
| Migration | Expand schema nullable; deploy before backfill ([[migration-path]]) |
| Refactor | One module moved; all tests green; behavior unchanged |

Each slice should answer: **"What can I demo or test after this?"** If nothing — slice smaller.

### 2. Size increments for review and rollback

Target increments that:

- Fit in **one focused session** (hours, not days)
- Produce a **diff reviewers can understand** in one pass ([[review-gate]])
- Leave a **revertible checkpoint** if deploy goes wrong ([[launch-readiness]])

| Too big | Right size |
|---------|------------|
| Entire checkout flow | Guest can submit email on checkout step 1 |
| All admin CRUD | List view with pagination |
| "Implement auth" | Login form posts; session cookie set; protected route redirects |

If a slice feels large, split: **data path** then **polish**; **read path** then **write path**; **happy
path** then **error states** ([[ui-craft]]).

### 3. The increment loop

For each slice, repeat until the spec is satisfied:

```text
1. Define slice outcome — one sentence + how you'll verify
2. Implement minimum to reach outcome (pair with [[test-first]] when logic-heavy)
3. Verify immediately — tests, run app, browser if UI ([[browser-checks]])
4. Commit at green ([[git-flow]]) — one logical change
5. Integrate often — rebase/merge main; don't drift for days
6. Next slice
```

**Verify before the next slice starts.** A failure you ignore compounds — you won't know which slice
introduced it.

**Stop rule:** If you've written a lot without running anything — **stop**, run tests, get back to
green, commit or stash. Never stack unverified work.

### 4. Verify each increment — prove it works

Verification matches the slice — not always full suite theater:

| Slice type | Verify with |
|------------|-------------|
| Logic / service | Unit/integration test ([[test-first]]) |
| API | Contract test + curl/httpie; check response body |
| UI component | Story or render test + [[browser-checks]] on wired page |
| Migration | Migration up on staging DB; row counts; app still boots |
| Config/deploy | CI green; smoke in staging ([[pipeline-ops]]) |

**Demo the slice** when possible — 30-second screen share beats "tests pass" for alignment.

For UI, don't wait until the whole page is pretty — prove the **wiring** early (data shows up, button
does something).

### 5. Commit at green — checkpoints are currency

Each green increment is:

- A safe **rollback target** ([[git-flow]], [[incident-response]])
- A **bisect point** for [[fault-recovery]]
- A **review unit** if you open PR early

**One logical change per commit** — not refactor + feature + lint fix in one blob.

WIP on private branch is fine; **before PR**, history should tell a story or squash per team convention.

Push slices regularly — laptop loss and silent drift are real risks.

### 6. Separate behavior from refactor

Mixed diffs are unreviewable and unbisectable:

```text
Commit A: extract OrderService (tests green, no behavior change)
Commit B: add tax calculation (tests new behavior)
```

Never "while I'm here" refactor across the feature unless refactor is its own slice first
([[simplify]] can guide cleanup passes).

### 7. Stubs, flags, and dark shipping

Use **temporary bridges** to keep slices vertical without building everything:

- **Stub** downstream dependency — real HTTP shape, fake data — replace in slice 2
- **Feature flag** — ship slice to prod dark; enable for internal users ([[launch-readiness]])
- **Interface behind implementation** — real caller, fake provider until integration slice

Mark stubs clearly — ticket or comment linking to the slice that removes them. Permanent stubs become
debt.

**Expand-contract** migrations: each expand/contract step is its own shippable increment
([[migration-path]]).

### 8. Integrate continuously

Long-lived branches are incremental delivery failure:

- **Merge or rebase `main` daily** (or more) — conflicts grow with time
- **Open draft PR early** — CI runs; reviewers see direction
- **Split oversized work** into stacked or sequential PRs — don't land 3k lines Friday

If integration hurts, slices may be too wide or branch lived too long — fix process, not blame git.

### 9. When a slice goes wrong

1. **Don't pile on** — stop next slice work
2. **Identify last green** — `git log`, CI history
3. **Revert or fix one slice** — [[fault-recovery]] with narrow surface
4. **Re-verify green** before continuing

Two broken slices ahead = go back to last green, not forward faster.

### 10. Scenario playbooks

**New API feature**

Slice: schema/migration expand → model + one endpoint happy path → validation/errors → authz →
remaining endpoints → contract cleanup.

**New UI page** ([[design-handoff]])

Slice: route + skeleton layout → one section with real data → remaining sections → states (loading/
empty/error) → responsive/a11y polish → browser-check proof.

**Replace legacy module**

Slice: adapter calls legacy → move one caller → move next caller → delete legacy when zero callers
([[migration-path]]).

**Performance fix** ([[perf-budget]])

Measure → one bottleneck fix → measure again → commit. Don't bundle five optimizations.

**Bug fix**

Repro test ([[test-first]]) → minimal fix green → commit. Not bundled with nearby feature.

**Spike / prototype**

Time-box; **throwaway or harden** — if spike code ships, first slice after spike is "make it real"
with tests, not more spike on spike.

**AI-generated implementation**

Treat output as untrusted: slice by slice, run tests each slice, reject 500-line dumps — regenerate
in smaller chunks.

## Common Rationalizations

- "I'll test it once it's all wired up." — Failure could be in any of ten places; you'll find it late.
- "Smaller commits are noisy." — Small green commits are the cheapest debugging and review tool.
- "Refactoring and the feature are the same change." — Mixing makes both impossible to review.
- "It's faster to build it all then fix it." — Integration debugging at the end kills schedules.
- "Vertical slices are harder upfront." — They're easier every day after; horizontal pays pain at the end.
- "We can't ship half a feature." — Dark flags and internal dogfood are shipping; half-built layers aren't.
- "Main moves too fast to merge often." — That's why you merge often; long drift is the problem.
- "Draft PR is embarrassing." — Early PR catches wrong direction cheaply.

## Red Flags

- Hundreds of lines written with nothing run yet
- Branch not in a working state for more than a day
- Single commit mixes refactor, feature, and drive-by fix
- "It'll all come together at the end"
- Can't name the last known-good commit
- Horizontal layers built with no end-to-end test path
- Stubs without tickets to replace them
- PR over team size limit with no split plan
- Tests added only in the final slice
- UI built entirely in static mock before any real data wiring
- Increment loop skipped — jumped from plan to "implement feature" task

## Verification

- [ ] Work decomposed into vertical slices with defined outcomes ([[work-planning]])
- [ ] Each slice demonstrable or testable — not horizontal-only layers
- [ ] Increment loop followed: implement → verify → commit at green → integrate
- [ ] Tests or manual/browser proof before starting next slice ([[test-first]], [[browser-checks]])
- [ ] Commits single-purpose; refactors separated ([[git-flow]])
- [ ] Stubs/flags documented with removal slice; migrations expand-contract ([[migration-path]])
- [ ] Branch merged with main regularly; PR size reviewable ([[review-gate]])
- [ ] Last known-good checkpoint identifiable; no long broken stretch
- [ ] Spec satisfied incrementally — not one big bang at the end
