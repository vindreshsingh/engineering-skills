---
name: e2e-testing
description: Writes and runs end-to-end tests that prove critical user flows work in a real browser. Use when unit tests pass but user journeys need verification, before release of UI flows, or when regressions happen only in full-stack integration.
---

# E2E Testing

Unit tests prove functions work; **E2E tests prove users can complete journeys**. A checkout flow,
login, or "first connection" path that only works in isolation is not shippable — exercise it in a
real browser against a running app.

Pairs with [[test-first]] for unit/integration layers, [[browser-checks]] for manual/exploratory
verification, [[spec-first]] for scenarios to automate, [[pipeline-ops]] to run E2E in CI, and
[[launch-readiness]] before promoting to production.

Use the [e2e testing checklist](../../references/e2e-testing-checklist.md) alongside this process.

## When to Use

- Critical user journey must not break (auth, signup, payment, core feature path)
- Bug only reproduces full-stack or in browser
- Before release of a new UI flow
- After refactor touching routing, auth, or API integration
- Replacing manual regression with automated smoke suite

Skip for pure backend/API changes with no user journey impact — use [[test-first]] only.

## Process

### 1. Pick flows — not every screen

Prioritize by risk and frequency:

| Tier | Examples | E2E depth |
|------|----------|-----------|
| **P0 smoke** | Login, signup, core happy path | Every PR / nightly |
| **P1** | Settings, secondary flows | Nightly |
| **P2** | Edge cases, admin | Weekly or pre-release |

Start with **3–5 P0 flows** max — flaky huge suites get ignored.

### 2. Write scenarios from spec

Each test = one user goal from [[spec-first]] acceptance criteria:

```text
Given [starting state]
When  [user actions]
Then  [observable outcome]
```

One behavior per test. Name tests after the user outcome, not the selector.

### 3. Choose stack and conventions

Pick one and stick to it:

- **Playwright** — recommended for modern web (Chromium, Firefox, WebKit)
- **Cypress** — good DX for React apps

Conventions:

- `data-testid` for stable selectors — avoid CSS classes and nth-child
- Page object or fixture pattern when flows share steps
- Seed test data via API or factory — don't depend on prod data
- Run against **staging** or local with test DB — never prod

### 4. Implement — arrange, act, assert

```text
1. Arrange — seed user/data, navigate to start URL
2. Act     — user clicks, fills, submits (one journey)
3. Assert  — URL, visible text, API side effect, DB state
4. Cleanup — delete test user/data if needed
```

Rules:

- **No arbitrary sleeps** — wait for network idle, selector, or API response
- **Isolate tests** — each can run alone and in parallel
- **Deterministic data** — unique emails (`test+${runId}@example.com`)
- **Capture artifacts on failure** — screenshot, trace, video in CI

### 5. Wire into CI ([[pipeline-ops]])

- Run P0 smoke on PR (allow 5–10 min budget)
- Full suite nightly
- Fail PR on P0 break; quarantine flaky tests within 24h — don't mute forever
- Store traces as CI artifacts

### 6. Maintain — flaky is failure

- Retry max 1–2 in CI only after fixing root cause
- Track flaky rate; >2% means investigate selectors or timing
- Update tests when intentional UI change — same PR as code

## Common Rationalizations

- **"Unit tests cover it"** — Integration gaps hide in wiring, routing, and cookies.
- **"E2E is too slow for CI"** — Run smoke only on PR; full suite nightly.
- **"We'll add E2E later"** — Later never comes; P0 flows first.
- **"Sleep 3 seconds works"** — Flakes follow; use proper waits.

## Red Flags

- Tests depend on execution order
- Hard-coded prod URLs or credentials
- Selectors tied to CSS modules that change weekly
- Suite disabled in CI "temporarily" for months
- No test for the primary revenue or signup path

## Verification

- [ ] P0 flows identified (3–5 max) with spec traceability
- [ ] Tests use stable selectors and deterministic data
- [ ] Each test runs isolated; no sleep-based waits
- [ ] P0 smoke runs in CI on PR
- [ ] Failure artifacts (screenshot/trace) configured
- [ ] Flaky tests quarantined or fixed — not ignored
