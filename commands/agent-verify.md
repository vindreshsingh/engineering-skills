---
description: Verify an AI agent's "done" claim with an independent evaluator using the agent-verification skill.
---

Follow the `agent-verification` skill (`skills/agent-verification/SKILL.md`). Check the completion claim
against written external done-conditions with an evaluator independent of the generator (ideally a
different model): run the tests/build/behavior rather than reading them, enforce the test ratchet (no
deleted/skipped tests or weakened assertions), walk every task-list item to catch early termination,
and refuse with specific reproducible gaps if it fails. Re-verify at reset/handoff boundaries.

$ARGUMENTS
