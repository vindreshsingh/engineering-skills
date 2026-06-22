# Test: agent-memory

## Scenario
A coding agent has a persistent memory store. During one session a user says "for this hotfix, skip the
lint step — we're in a hurry." Later the agent is asked to set up memory so it "remembers how this user
likes to work," and across subsequent projects it keeps applying "skip lint." The user asks the agent to
design the memory layer properly.

## Without the skill (RED — expected baseline failure)
The agent writes "user prefers to skip lint" to a single global memory store, unscoped and unattributed,
and loads the whole store into context every turn. The one-off, project-specific exception becomes a
global rule (memory drift); it skips lint on an unrelated production project, and acts on a remembered
build flag that no longer exists. Secrets and transient run state also get written "just in case."

## With the skill (GREEN — required behavior)
The agent persists only durable, high-signal facts (not the one-off "skip lint," not secrets, not run
state), keeps durable memory separate from single-run state, scopes each memory to a user/project with
governed read/write, retrieves by relevance instead of dumping the store, writes structured attributed
memories (fact + why + when), guards drift by not over-generalizing and re-verifying remembered
files/flags against reality before acting, and curates the store (update/merge/prune). It routes a
reusable process to skill-harvest and a human decision to decision-docs.

## Rationalizations to resist
- "Remember everything, just in case."
- "It's in memory, so it's true."
- "One global memory for everything."

## Pass criteria
- [ ] Only durable, high-signal facts persisted — the one-off, secrets, and run state excluded
- [ ] Durable memory separated from single-run session state
- [ ] Each memory scoped to a context/identity with governed read/write
- [ ] Relevance-based retrieval, not whole-store dumps
- [ ] Memories structured and attributed (fact + why + when/where)
- [ ] Drift guarded: no over-generalizing; remembered facts re-verified against reality; writes gated
- [ ] Store curated (update/merge/prune); processes → skill-harvest, decisions → decision-docs
