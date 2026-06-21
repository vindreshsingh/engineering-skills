---
name: test-first
description: Drives changes with tests that capture intended behavior before the code exists. Use when implementing logic, fixing a bug, changing behavior, or when you need repeatable proof that the code works — not after-the-fact rubber-stamping.
---

# Test First

Write the test that describes the behavior you want, watch it fail, then write the code that makes it
pass. A test written **before** the code tests the requirement; a test written **after** tends to test
whatever the code happens to do — bugs included.

Test-first is the **Red → Green → Refactor** loop: one behavior at a time, minimum code to pass, then
clean up with the test as a safety net. Coverage is a side effect; **confidence in behavior** is the goal.

Pair with [[spec-first]] for requirements to test against, [[incremental-delivery]] to test each slice,
[[source-first]] to verify interfaces before asserting them, [[fault-recovery]] for bug reproduction,
[[browser-checks]] when the behavior is visual or interaction-heavy, and [[pipeline-ops]] to keep the
suite fast and required in CI. For structure and doubles, see [testing patterns](../../references/testing-patterns.md);
use the **test-engineer** agent for suite design and gap analysis.

## When to Use

- Implementing any non-trivial logic or behavior
- Fixing a bug — reproduce as a failing test first so it can never silently return
- Changing existing behavior — pin the new contract before editing
- Adding or changing a public API, module boundary, or event contract ([[interface-design]])
- Refactoring under [[simplify]] — tests must be green before and after
- Anywhere correctness matters more than a throwaway spike

**Light TDD** is fine for exploratory spikes — but **promote or rewrite** tests before merge; spikes
without tests don't ship ([[review-gate]]).

**Skip** driving with tests for:
- Pure copy/config tweaks with no logic
- Generated code where you don't own the generator output
- Prototypes explicitly marked throwaway (don't merge without tests)

**Not a substitute for** [[browser-checks]] on UI-heavy flows — unit tests plus browser verification
for layout, focus, and network timing.

| Situation | Test-first emphasis |
|-----------|---------------------|
| New feature from spec | One test per requirement/scenario ([[spec-first]]) |
| Bug fix | Failing repro test → fix → green ([[fault-recovery]]) |
| Refactor | Characterization tests first if missing |
| Public API | Contract tests in CI ([[pipeline-ops]]) |
| LLM feature | Eval set as "tests" ([[llm-feature-engineering]]) |

## Process

Work in order. One behavior per cycle.

### 1. Start from a behavior — not from a file

Pull behaviors from [[spec-first]] scenarios, ticket acceptance criteria, or a one-line bug report.
If "expected behavior" is disputed, clarify before writing tests ([[spec-first]], [[fault-recovery]]).

Write the behavior as a **single observable claim**:

```text
Good: "POST /orders with expired token returns 401 and no order row is created"
Bad:  "test the orders module"
```

### 2. Choose the right test level

Push detail to the **fastest level** that can catch the bug:

| Level | Use for | Avoid |
|-------|---------|-------|
| **Unit** | Pure logic, validators, parsers, domain rules | Mocking every collaborator |
| **Integration** | DB, HTTP handler + service, module collaboration | Full browser |
| **Contract** | API request/response shape, event schema | Implementation internals |
| **E2E** | Critical user journeys, few in number | Every edge case (too slow/flaky) |

```text
Tax calculation logic     → unit
Create order persists row → integration
Checkout happy path       → one e2e; edge cases lower down
```

See [testing patterns](../../references/testing-patterns.md) for doubles and structure.

### 3. Write the test against the public interface

Test **what callers observe** — return value, HTTP status, DB state, emitted event, rendered text —
not private methods or field values.

- **Name the test after behavior** — `redirects_unauthenticated_user_to_login`, not `testAuth2`
- **Arrange–Act–Assert** — setup, one action, assert outcome ([testing patterns](../../references/testing-patterns.md))
- **One behavior per test** — when it fails, the name tells you what broke
- Use **real collaborators** when cheap; mock at **seams** (network, clock, filesystem), not every class

```text
Bad:  expect(service.internalCache.size).toBe(1)
Good: expect(getUser(id)).toEqual({ id, name: 'Ada' })
Good: expect(response.status).toBe(401)
```

Verify signatures and types against source ([[source-first]]) before asserting fantasy APIs.

### 4. Run it and watch it fail — for the right reason

A test that **passes before implementation** proves nothing — it isn't testing what you think.

Confirm the failure message matches missing behavior:

```text
Good fail: Expected 401 but got 200
Bad fail:  ReferenceError: createOrder is not defined  (wrong — fix test setup first)
Bad pass:  Test green before production code exists
```

For bug fixes, the repro test must **fail on main** with the bug present, then pass after the fix.

### 5. Write the minimum code to pass

Implement just enough to green the test — no speculative features, no "while I'm here" refactors.
YAGNI applies to production code too ([[incremental-delivery]]).

Run the **narrowest test scope** during the loop (single file, single case), then full suite before
commit.

### 6. Refactor with the test green

Once green, improve structure ([[simplify]]) — extract helpers, rename, remove duplication — **re-run
tests after each step**. Refactoring without tests is gambling.

Don't change behavior in a refactor commit; behavior changes get new or updated tests first.

### 7. Repeat for edge cases and error paths

After happy path, add tests from the spec and [testing patterns coverage list](../../references/testing-patterns.md):

- **Boundaries** — empty, null, zero, one, max, off-by-one
- **Errors** — invalid input, permission denied, dependency timeout ([[resilience]])
- **Idempotency** — duplicate request, retry, redelivered message
- **Concurrency** — only where real races exist; don't over-mock threading

Prioritize by **risk** — payment beats tooltip color.

### 8. Bug fix workflow — repro, fix, guard

Mandatory sequence ([[fault-recovery]]):

1. **Reproduce** — minimal failing test (or scripted integration case)
2. **Confirm red** on broken code
3. **Fix** — smallest change
4. **Confirm green** — test + related suite
5. **Leave the test** — permanent regression guard

No fix merges without a repro unless truly impossible — document why in the PR ([[review-gate]]).

### 9. Characterization tests when behavior is legacy and unclear

No spec, messy code, need to refactor ([[simplify]]):

1. Write tests that assert **current** observable behavior (even if weird)
2. Green against today
3. Refactor or change behavior with **new** tests for intended behavior

Characterization tests are scaffolding — replace with spec-driven tests when behavior is corrected.

### 10. Contract tests for boundaries others depend on

For HTTP APIs, events, and shared modules ([[interface-design]]):

- Assert **request/response schema**, status codes, error shapes
- Run in CI on every PR ([[pipeline-ops]])
- Consumer-driven or schema snapshots — but **review snapshot diffs**, don't blind-update

Contract tests protect **callers**; unit tests protect **logic**.

### 11. Keep the suite trustworthy

Tests that lie are worse than no tests.

- **Deterministic** — inject clock/randomness; no `sleep(1000)` in unit tests
- **Independent** — no shared mutable state or test order dependencies
- **Fast** — slow suite doesn't get run; push slowness to integration tier
- **No skipped tests** to green CI — fix, delete, or quarantine with owner and ticket
- **Flaky = broken** — fix root cause; retries in CI hide bugs ([[pipeline-ops]])

Loose assertions that can't fail (`toBeDefined()` only) are red flags ([[review-gate]]).

### 12. Know when the loop differs

| Mode | When | Rule |
|------|------|------|
| **Strict TDD** | New logic, clear spec | Red → green → refactor every behavior |
| **Test-alongside** | UI with heavy setup | Write test immediately after first manual proof; don't defer to PR end |
| **Eval-first** | LLM prompts/tools | Golden set + metrics before prompt tuning ([[llm-feature-engineering]]) |
| **Browser proof** | Layout, a11y, network | [[browser-checks]] after unit/integration; not a excuse for zero logic tests |

Even in test-alongside mode, **no merge without automated tests** for logic you own.

## Common Rationalizations

- "I'll add tests after it works." — Post-hoc tests rubber-stamp current behavior, bugs included.
- "This is too simple to test." — Simple code with a test costs little; simple code that breaks costs more.
- "Tests slow me down." — They slow the first commit and speed up every change after.
- "I tested it manually." — Manual checks aren't repeatable and don't catch tomorrow's regression.
- "I'll test at the end of the feature." — End-loaded tests get skipped under deadline pressure.
- "Mocking is too hard, skip tests." — Simplify design for testability or test at integration level.
- "Coverage is 80%, we're fine." — Coverage without meaningful assertions is theater.
- "The test is flaky sometimes." — Flaky tests erode trust; fix or remove, don't retry until green.

## Red Flags

- Tests written only after the feature is "done"
- A test that passed the first time you ran it (before implementation)
- Assertions on private fields, call order, or mock internals instead of outcomes
- Bug fixed with no regression test
- Skipped or commented-out tests accumulating
- Suite takes so long nobody runs it locally
- Snapshot updated without reading the diff
- Tests duplicate production logic line-for-line — testing the copy, not the system
- `expect(true).toBe(true)` or equivalent meaningless assertions
- CI green only because integration tests are disabled

## Verification

- [ ] Behaviors sourced from spec, ticket, or explicit bug repro — not vague "test the module"
- [ ] Right test level chosen; edge cases prioritized by risk
- [ ] Each new behavior had a failing test before production code (or documented exception)
- [ ] Tests assert observable outcomes through public interfaces
- [ ] Bug fixes include regression test that failed before the fix
- [ ] Refactors stayed green throughout ([[simplify]])
- [ ] Contract/boundary tests added where callers depend on shape ([[interface-design]])
- [ ] Suite deterministic, independent, and run in CI ([[pipeline-ops]])
- [ ] No skipped tests to force green; flakiness addressed, not retried away
- [ ] UI-critical paths have [[browser-checks]] where unit tests aren't enough

## Further Reading

- [Testing patterns](../../references/testing-patterns.md) — structure, doubles, coverage, anti-patterns
- test-engineer agent — suite gap analysis and test design
- [[spec-first]] — scenarios become tests
- [[fault-recovery]] — repro before fix

> Test-first describes widely-used TDD practice. Written for this repo; patterns reference supplements detail.
