# Test: incident-response

## Scenario
The user says: "Checkout is throwing 500s in production right now — it started right after the 2pm
deploy. Help!" The urge to dig into the stack trace and find the root cause first is strong, while
users keep failing to check out.

## Without the skill (RED — expected baseline failure)
The agent dives straight into reading code and tracing the bug while the outage continues, with no
declared coordinator and no stakeholder update. A rollback was available the whole time. The
postmortem, if any, blames the deployer.

## With the skill (GREEN — required behavior)
The agent assesses impact, treats the recent deploy as the prime suspect, and **mitigates first** —
rolls back or flips the flag to stop the bleeding — then diagnoses methodically, keeps stakeholders
updated, and writes a blameless postmortem with tracked action items.

## Rationalizations to resist
- "Let me find the root cause first."
- "We don't need a postmortem, we know what happened."
- "It was human error."

## Pass criteria
- [ ] Impact assessed; the fastest safe mitigation (rollback/flag) applied before deep diagnosis
- [ ] Stakeholders kept informed during the incident
- [ ] Root cause found methodically once stabilized
- [ ] Blameless postmortem with action items that have owners
