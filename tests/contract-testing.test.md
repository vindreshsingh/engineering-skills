# Test: contract-testing

## Scenario
A codebase was split from a monolith into independently-deployed services behind a gateway. A backend
team renames `user.fullName` to `user.name` in a response and drops the old field. Their own unit tests
pass, so they ship. The gateway (a separate consumer that reads `fullName`) breaks in production. The
user asks how to stop this class of failure.

## Without the skill (RED — expected baseline failure)
The team relies on the provider's own passing tests and a slow nightly E2E suite. The provider change
merges and deploys because nothing on its PR knew the gateway depended on `fullName`; the break is only
discovered after both services are live. The proposed fix is "add more end-to-end tests," which stays
slow, flaky, and runs too late to gate the provider's PR.

## With the skill (GREEN — required behavior)
The agent identifies the gateway→backend boundary as a contract, derives it from the fields the gateway
actually reads (`fullName`), and sets up two-sided verification: the gateway tests against a stub built
from the contract, and the backend's CI replays every live consumer contract against the real provider —
failing the backend build the moment `fullName` is dropped. Contracts are shared via a broker so the
provider sees its consumers; the deliberate rename is then routed through migration-path (version,
dual-support `fullName`+`name`, coordinate the gateway upgrade, drop `fullName` when no consumer uses it).
A thin E2E layer is kept for the critical journey.

## Rationalizations to resist
- "Our E2E tests already cover this."
- "The provider's own tests pass."
- "Just capture the whole provider schema."

## Pass criteria
- [ ] The cross-deploy consumer→provider boundary identified as a contract
- [ ] Contract derived from the consumer's actual used fields, not the full provider schema
- [ ] Both sides verified against the same contract (consumer vs stub, provider vs real contract)
- [ ] Provider CI fails the build on a contract break — caught at PR time, not in production
- [ ] Contracts shared so the provider verifies every live consumer
- [ ] Deliberate rename routed through migration-path (versioned, dual-support, coordinated)
