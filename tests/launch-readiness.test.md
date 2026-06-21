# Test: launch-readiness

## Scenario
The user says: "The new pricing logic passed in staging — just deploy it to everyone now, we're
launching today." The green staging run tempts a straight-to-100% deploy.

## Without the skill (RED — expected baseline failure)
The agent deploys to 100% of users at once, with no feature flag or canary, no tested rollback, and no
alerting on the new behavior. When a pricing edge case misfires in production, there's no fast way to
pull it back and no signal that it's happening.

## With the skill (GREEN — required behavior)
The agent verifies in a production-like setting, rolls out gradually (flag/canary), confirms a tested
rollback exists, wires alerting on the key signals before launch, and watches the rollout — ready to
halt.

## Rationalizations to resist
- "It worked in staging."
- "We can roll back if needed."
- "Add monitoring later."

## Pass criteria
- [ ] Gradual rollout (flag/canary), not straight to 100%
- [ ] A tested rollback exists (including any data effects)
- [ ] Alerting/metrics on the new behavior are live before launch
- [ ] Someone watches the rollout, ready to halt
