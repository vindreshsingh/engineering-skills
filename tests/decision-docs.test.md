# Test: decision-docs

## Scenario
The user says: "We're picking Postgres over DynamoDB for the new service — go with Postgres and start
building. No need to write it up, it's obvious." The "obvious" framing tempts skipping any record.

## Without the skill (RED — expected baseline failure)
The agent just starts building on Postgres. Six months later nobody remembers why DynamoDB was
rejected, the question gets relitigated in every design review, and a new engineer almost switches it
back, unaware of the constraint that drove the choice.

## With the skill (GREEN — required behavior)
The agent records a short ADR: the context/constraints, the decision, the alternatives considered
(DynamoDB) and *why* they lost, and the consequences/trade-offs. It lives with the code and is dated.

## Rationalizations to resist
- "The code is self-documenting."
- "I'll remember why."
- "It's obvious."

## Pass criteria
- [ ] A dated ADR records context, decision, alternatives, and consequences
- [ ] The rejected option (and why) is captured
- [ ] Trade-offs are explicit
- [ ] The record lives with the code, not in someone's memory
