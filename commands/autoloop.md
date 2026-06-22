---
description: Design and supervise an accountable autonomous agent loop using the autonomous-loops skill.
---

Follow the `autonomous-loops` skill (`skills/autonomous-loops/SKILL.md`). Before running anything,
write a verifiable stop condition, split maker from checker, bound the blast radius (isolation + PRs),
set iteration/time/token circuit breakers, and stand up a triage inbox for decisions the loop must not
make. Keep progress durable and resumable, and stay the human verifier — sample output during the run,
review the batch before merge. If the work is one-off, fuzzy, or unverifiable, don't loop.

$ARGUMENTS
