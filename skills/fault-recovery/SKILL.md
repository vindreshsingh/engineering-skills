---
name: fault-recovery
description: A disciplined method for debugging and recovering from failures. Use when something breaks, behaves unexpectedly, a test fails, an error appears, or a bug is intermittent — instead of guessing at fixes or stacking random edits.
---

# Fault Recovery

Debug by **narrowing**, not by guessing. Random edits hide bugs more often than they fix them — and
leave you unsure which change mattered. Reproduce the failure reliably, read what the system actually
said, isolate the smallest trigger, test **one hypothesis at a time**, fix the **cause**, and lock it
with a regression test.

This skill is for **methodical diagnosis** in dev, CI, staging, or post-mitigation production
investigation. When users are actively impacted and you need to **stop the bleeding first**, pair with
[[incident-response]] — mitigate before deep root-cause work. For preventing failures at boundaries,
see [[resilience]]. For telemetry during diagnosis, see [[observability]].

## When to Use

- A crash, exception, failing test, or wrong output
- Behavior that contradicts what the code should do
- A regression after a deploy or local change
- Flaky or intermittent failures — "works sometimes"
- A bug report that needs reproduction before fix
- Browser-only or environment-specific failures ([[browser-checks]])
- Post-incident root-cause analysis after service is stable ([[incident-response]])

Skip the full process for a typo with an obvious one-line fix — but still confirm with a test or
reproduction if the surface area isn't trivial.

**Not this skill alone:** active production outage with no mitigation → [[incident-response]] first.

## Process

Work in order. Don't edit code until reproduction and the error are understood.

### 1. Capture what you know — before touching code

Write a **failure record** — even three lines — so you don't lose facts while guessing:

```text
Expected: checkout total includes tax for EU addresses
Actual: tax line shows €0.00
First seen: after commit abc123 / in CI job X / only on Safari
Repro rate: always / ~30% / only under load
Error text: (paste or link)
```

If you can't fill **expected vs actual**, clarify with the reporter ([[spec-first]]) before debugging.

### 2. Reproduce it reliably

A bug you can't trigger on demand, you can't prove you fixed.

**Make reproduction deterministic:**

- Pin **inputs** — exact URL, user role, feature flags, request payload, seed data
- Pin **environment** — OS, browser, Node/Python version, env vars, local vs CI
- Pin **timing** — race bugs need a script or stress loop, not "I clicked fast"
- **Minimize steps** — shortest path from cold start to failure

If intermittent:

- Run repeatedly (`--repeat`, loop script) to estimate frequency
- Look for **shared preconditions** — cache state, clock, concurrency, test order
- Check **test pollution** — does it pass alone but fail in the full suite?

No repro after reasonable effort → gather more telemetry ([[observability]]), add logging at
boundaries, or pair with the reporter. Don't "fix" what you can't see fail.

### 3. Read the actual error — fully

The message, stack trace, and logs usually name the neighborhood. Read them **before** theorizing.

**Stack traces**

- Start at the **top meaningful frame in your code** — not the framework wrapper
- Walk **caused by** chains — root exception may be deeper
- Note **file, line, and function** — open that code before editing elsewhere

**Logs**

- Filter by request/correlation id ([[observability]])
- Read **surrounding context** — what happened in the 10 lines before the error?
- Check **level** — is this the first error or a downstream symptom?

**Tests**

- Read the **assertion message** — expected vs actual often pin the bug
- Run the **single failing test** isolated — `pytest path::test`, `npm test -- -t name`

**Generic errors** ("Internal Server Error", "Something went wrong") still point somewhere — trace
from the handler to where the real exception was swallowed ([[resilience]] red flag).

### 4. Narrow the surface

Shrink the problem space until the failure is **small and local**.

**Git bisect** — regression after a range of commits:

```bash
git bisect start
git bisect bad          # current broken
git bisect good <sha>   # known good
# test each step; git bisect good/bad until found
git bisect reset
```

**Code bisect** — disable, stub, or bypass halves:

- Comment out middleware, feature branches, or optional steps
- Replace remote call with fixture — does it still fail?
- Binary search through a pipeline: parse → validate → transform → persist

**Input minimization** — shrink to smallest failing case:

- Smallest JSON payload, shortest string, single row in DB
- HTML/CSS bisect for layout bugs — remove sections until failure stops

**Scope by layer**

| Symptom layer | Narrow to |
|---------------|-----------|
| UI wrong | DOM/state → network response → server logic → data |
| API wrong | Handler → service → DB query → external dependency |
| Test only in CI | Env diff, parallelism, timing, file order |
| Production only | Config, scale, data shape, deploy artifact |

Document what you ruled out — "not the database" is progress.

### 5. Form one hypothesis

A hypothesis is a **testable statement** that explains **all** observed evidence:

```text
Bad: "Something's wrong with tax"
Good: "Tax is zero because regionCode is null when EU address uses legacy ISO field"
```

One hypothesis at a time. If you have two equally likely theories, pick the one you can **disprove
fastest** (cheapest experiment).

Confirm assumptions against source ([[source-first]]) — API signature, default value, query result —
not memory of how it "should" work.

### 6. Test with a single change

Change **one thing**, observe, record result. Repeat.

| Do | Don't |
|----|-------|
| Add one log line at suspect boundary | Refactor while "debugging" |
| Toggle one flag | Change timeout + retry + query together |
| Patch one branch | "Cleanup" unrelated code in same commit |
| Revert one commit to confirm | Stack five speculative fixes |

Keep a **debug log** for non-obvious sessions:

```text
H1: null region → added log in TaxService → regionCode null on EU path → confirmed
H2: legacy field not mapped → fixed mapper → test green
```

If a change doesn't help, **revert it** before the next experiment. Debug commits should not accumulate
noise.

**Prove the hypothesis:**

- Does the failure disappear when you undo the suspected cause?
- Does artificially triggering the cause reproduce the failure again?

### 7. Fix the cause, not the symptom

| Symptom fix (avoid) | Cause fix (prefer) |
|---------------------|-------------------|
| `catch (e) {}` | Why did the exception throw? |
| Retry until pass | Why did the first attempt fail? |
| `if (x == null) return 0` | Why is x null on a valid path? |
| Hide error in UI | Why did the API return 500? |
| `@ts-ignore` | Fix the type or contract |

Symptom fixes ship silence — the bug persists or corrupts data elsewhere. If a workaround is required
temporarily (production hotfix), track a follow-up to fix root cause ([[incident-response]]).

### 8. Lock it in with a regression test

Before closing the bug ([[test-first]]):

1. **Failing test** that reproduces the bug (or the minimal case you isolated)
2. **Fix** the cause
3. **Test green** — proves fix and guards against return
4. **Related cases** — edge cases the bug revealed

Name the test after the behavior: `applies_eu_tax_when_legacy_region_field_set`.

For flaky bugs, the test may need deterministic timing or explicit ordering — document why.

### 9. If stuck — widen the lens systematically

After **one focused hour** (or two failed hypotheses with no new data), check common non-code causes:

**Environment & versions**

- Dependency version diff local vs CI ([[dependency-hygiene]])
- Wrong env var, missing secret, stale `.env`
- Node/Java/Python version mismatch
- Docker image not rebuilt

**Data**

- Production data shape vs fixture — nulls, unicode, huge values, time zones
- Stale cache, migration not applied, seed out of date
- Wrong tenant/user context

**Concurrency & timing**

- Race between async steps — add ordering or await
- Test parallelization — `pytest -n0` to compare
- Clock skew, TTL expiry, debounce timing

**Assumptions**

- List what you "know" — verify each against source ([[source-first]])
- Ask: what would I expect to see in logs if this theory were true? Do I see it?

**Get a second pair of eyes** with the failure record and debug log — not "it doesn't work."

**Time-box** — if still stuck, escalate: more telemetry, pair debug, or scope reduction.

### 10. Scenario playbooks

**Failing unit/integration test**

1. Run isolated → read assertion → open test + implementation.
2. `git diff` recent changes if regression.
3. Hypothesis → single fix → green → keep test.

**CI-only failure**

1. Diff CI vs local: env vars, versions, services, parallelism.
2. Re-run failed job with debug logging enabled.
3. Reproduce in CI-like container locally.

**Flaky test**

1. Estimate rate — loop 100×.
2. Run alone vs full suite — order dependency?
3. Fix determinism: fixed clock, seeded RNG, await async, isolate shared state.
4. Never "retry 3×" as the only fix without understanding why.

**Browser / UI bug** ([[browser-checks]])

1. Reproduce in browser with DevTools open — console, network first.
2. Compare network response to what UI shows — backend vs front-end split.
3. Narrow: component state → props → fetch → API.
4. Screenshot + HAR for intermittent UI issues.

**Wrong output, no exception**

1. Trace data flow from input to output — log at boundaries.
2. Find where value first goes wrong — bisect pipeline.
3. Often config, mapping, or unit mismatch — not algorithm.

**Production bug (service stable)**

1. Confirm mitigation if impact ongoing ([[incident-response]]).
2. Use traces/logs/metrics to find failing requests ([[observability]]).
3. Reproduce in staging with production-like data snapshot when possible.
4. Fix + test + staged rollout ([[launch-readiness]]).

**"Worked yesterday" regression**

1. `git bisect` or scan deploy changelog.
2. First bad commit → read that diff carefully — often one logical change.
3. Revert to confirm before forward fix.

## Common Rationalizations

- "I'll just try a few things." — Untracked changes create new bugs and hide the real one.
- "I don't need to reproduce it." — You can't prove the fix worked.
- "The error message is generic." — Trace deeper; generic often means swallowed exception.
- "It's probably a fluke." — Intermittent bugs have a condition you haven't found yet.
- "I'll add a quick fix and clean up later." — Quick symptom fixes become permanent debt.
- "Tests pass now, ship it." — Did you add a regression test? Did you run the full suite?
- "I know this API." — Verify against source; wrong mental models waste hours ([[source-first]]).
- "More logging everywhere." — Log at boundaries with correlation ids; don't flood and bury signal.

## Red Flags

- Changing code before reproducing the failure
- Multiple simultaneous edits with no record of which mattered
- Skimming the stack trace and guessing from the file name
- Fixing by masking — catch-ignore, retry-until-pass, hide error in UI
- Fix with no regression test ([[test-first]])
- Debugging production under active user impact without mitigation ([[incident-response]])
- `console.log` / `print` spam committed as the "fix"
- Flaky test "fixed" with retries only
- Same bug reopened twice — previous fix was symptom-only
- Hours spent without a written failure record or hypothesis list

## Verification

- [ ] Failure record written — expected vs actual, environment, repro steps
- [ ] Failure reproduced reliably (or repro gap documented with telemetry plan)
- [ ] Error, stack trace, and logs read fully — not skimmed
- [ ] Surface narrowed — git/code/input bisect; ruled-out areas noted
- [ ] One hypothesis tested at a time; debug log or clear commit history
- [ ] Suspect behavior confirmed against source ([[source-first]])
- [ ] Root cause fixed — not symptom masked without tracked follow-up
- [ ] Regression test added and full relevant suite green ([[test-first]])
- [ ] Flaky root cause addressed if applicable — not retry-only
- [ ] Production fix staged/rolled out with monitoring ([[launch-readiness]], [[observability]])
