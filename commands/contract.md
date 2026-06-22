---
description: Guard service boundaries with consumer-driven contract tests using the contract-testing skill.
---

Follow the `contract-testing` skill (`skills/contract-testing/SKILL.md`). Identify the cross-deploy
consumer→provider boundaries (sync and async), derive each contract from what the consumer actually
uses (not the full provider schema), verify both sides against the same contract, share contracts so
the provider checks every live consumer, and wire verification into CI so a contract break fails the
provider build. Route deliberate breaking changes through `migration-path`, and prune stale contracts.

$ARGUMENTS
