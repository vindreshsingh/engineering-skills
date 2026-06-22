---
description: Design and read out a valid A/B test using the experimentation skill.
---

Follow the `experimentation` skill (`skills/experimentation/SKILL.md`). Write a falsifiable hypothesis
with a mechanism before building, pick exactly one primary metric plus guardrail metrics, compute sample
size and duration up front, randomize at the right unit and verify the split, run to the pre-committed
stop without peeking, and read out honestly with confidence intervals (treating "no effect" and guardrail
regressions as real outcomes). Record the decision and clean up the flag/variant afterward.

$ARGUMENTS
