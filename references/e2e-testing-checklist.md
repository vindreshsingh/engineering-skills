# E2E Testing Checklist

Quick reference alongside [[e2e-testing]].

## Scope

- [ ] P0 flows identified (3–5 max)
- [ ] Each flow maps to spec acceptance criteria
- [ ] Out of scope flows explicitly deferred

## Test quality

- [ ] `data-testid` or stable selectors — no brittle CSS
- [ ] Deterministic test data (unique emails, seeded DB)
- [ ] No hard-coded sleeps — proper waits only
- [ ] Tests isolated — run alone and in parallel
- [ ] Cleanup after test (users, rows)

## CI

- [ ] P0 smoke on every PR
- [ ] Artifacts on failure (screenshot, trace, video)
- [ ] Runs against staging or ephemeral env — not prod
- [ ] Flaky tests quarantined within 24h

## Maintenance

- [ ] Tests updated in same PR as UI change
- [ ] No credentials in repo
- [ ] Suite runtime tracked — split if >15 min on PR
