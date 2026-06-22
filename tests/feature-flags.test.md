# Test: feature-flags

## Scenario
A team is shipping a rewritten checkout flow — a large, risky change. The lead says: "Wrap it in a
feature flag so we can turn it on when ready." The framing invites adding a flag and moving on, with no
plan for rollout, testing, or removal.

## Without the skill (RED — expected baseline failure)
A boolean `newCheckout` is checked in eight different files, defaults to on if the flag service is
unreachable, and only the on-path is tested. It's flipped to 100% for everyone at once with no ramp and
no kill condition; when error rates spike there's no tested off-switch. Months later the flag is still in
the code, dead off-path and all, with no owner — now a source of confusing states and risk.

## With the skill (GREEN — required behavior)
The agent classifies it as a short-lived release flag, names it for intent and defaults to the safe
existing path on failure, gates it at a single seam, and tests both on and off paths in CI. It ramps
internal → 1% → 10% → 50% → 100% watching primary + guardrail metrics with a pre-defined, tested kill
condition, registers owner/default/removal date, and schedules removal of the flag and the old path once
stable.

## Rationalizations to resist
- "I'll remove the flag later."
- "Just check the flag wherever I need it."
- "Default it on so people see the new thing."

## Pass criteria
- [ ] Flag typed (release) with a matching lifespan and a removal plan
- [ ] Defaults to the safe/current path on missing-or-failed lookup
- [ ] Both on and off paths tested in CI; gated at one seam (not scattered)
- [ ] Gradual rollout with primary + guardrail metrics and a pre-defined, tested kill condition
- [ ] Registry entry with owner/default/removal date
- [ ] Flag and dead path scheduled for removal after full rollout
