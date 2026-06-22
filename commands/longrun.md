---
description: Keep an agent coherent across hours/days with external state, checkpoints, and compaction using the long-running-agents skill.
---

Follow the `long-running-agents` skill (`skills/long-running-agents/SKILL.md`). Externalize the goal,
done-conditions, and task list to files; keep an append-only progress log; commit each meaningful unit;
compact context to a handoff file and reset before quality degrades; and make state reconstitutable so
a cold start resumes from files alone. For big runs, split planner/worker/judge. Resume, never restart.

$ARGUMENTS
