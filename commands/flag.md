---
description: Ship behind a feature flag and govern its lifecycle using the feature-flags skill.
---

Follow the `feature-flags` skill (`skills/feature-flags/SKILL.md`). Classify the flag's type and
lifespan, name it for intent and default to the safe path, test both on and off paths, gate at one seam
with no nested/combinatorial logic, roll out gradually against primary + guardrail metrics with a tested
kill condition, register owner/default/removal date, and remove release/experiment flags (and the dead
path) once rolled out or concluded.

$ARGUMENTS
