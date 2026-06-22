---
description: Design durable, governed cross-session agent memory using the agent-memory skill.
---

Follow the `agent-memory` skill (`skills/agent-memory/SKILL.md`). Persist only durable, high-signal
facts (no secrets, run state, or one-offs); keep memory separate from single-run state; scope each
memory to a context/identity with governed read/write; retrieve by relevance rather than dumping the
store; write structured, attributed memories; guard against drift and poisoning (don't over-generalize,
re-verify against reality, gate writes); and curate — update, merge, prune. Route reusable processes to
`skill-harvest` and human decisions to `decision-docs`.

$ARGUMENTS
