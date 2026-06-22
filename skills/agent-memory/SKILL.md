---
name: agent-memory
description: Designs durable, curated memory that an agent carries across sessions — what to persist, how to scope and retrieve it, and how to stop it from drifting or poisoning later runs. Use when an agent needs to remember decisions, preferences, or project facts beyond one context window, or when stale/over-generalized memory is corrupting its behavior.
---

# Agent Memory

Context is what an agent holds *now*; memory is what it carries *across* sessions. The two fail in
opposite directions: too little durable memory and the agent re-learns the same facts every run; too
much, or ungoverned, and it confidently applies a shortcut learned from one odd interaction to
everything (**memory drift**), or re-introduces a bug it "remembers" was fine. This skill is the
discipline for memory that helps instead of rots: persist the few things worth remembering, scope and
retrieve them deliberately, and govern what gets written so the store stays trustworthy.

Memory is distinct from the three things it's often confused with: [[context-curation]] decides what's
loaded *into a single session*; [[long-running-agents]] keeps *one run's* state (plan/progress/handoff)
durable and resumable; [[skill-harvest]] promotes a reusable lesson into the *skill library*. This
skill governs the agent's **cross-session, per-context memory store** — and links to all three.

## When to Use

- An agent should **remember** user preferences, prior decisions, or project facts beyond one window
- You're designing a **memory store / "memory bank"** — what it holds, who can read/write, how it's retrieved
- Memory is **corrupting behavior** — stale facts, over-generalized shortcuts, a re-introduced bug
- A long or looping run accumulates state and you must decide what graduates to durable memory
  ([[long-running-agents]], [[autonomous-loops]])

**Skip** when:
- The fact only matters for the current session — that's [[context-curation]], not durable memory
- The lesson is a reusable *process* for the team — that belongs in the skill library via [[skill-harvest]]
- It's a project decision humans need — record it in [[decision-docs]], which can also *feed* memory

**Not a substitute for** [[context-curation]] (in-session load) or [[long-running-agents]] (single-run
state) — memory is the layer that persists *between* them.

## Process

### 1. Decide what is worth remembering — bias to little
Persist only **durable, reusable** facts: stable user preferences, settled decisions and their reasons,
hard-won project constraints. Do **not** persist transient run state, anything secret, or one-off facts.
A small, high-signal store beats a large one the agent can't trust. When unsure, don't write it.

### 2. Separate memory from session state
Keep the durable **memory store** distinct from the current run's working state ([[long-running-agents]]
owns the latter). Session state is disposable per run; memory outlives runs. Conflating them is how
run-specific noise leaks into long-term memory and drifts behavior.

### 3. Scope memory to a context and an identity
Bind each memory to **whose** and **which** context it applies to (user, project, repo), and govern
**which agents may read or write** it. Unscoped global memory is how a fact true in one project
silently corrupts another. Least-privilege on writes especially.

### 4. Make retrieval deliberate, not ambient
Pull memory **by relevance to the task**, not by dumping the whole store into context every turn (that's
[[context-curation]]'s budget you'd blow). Prefer a searchable store with relevance lookup; load the few
memories that match, link related ones, and leave the rest at rest.

### 5. Write structured, attributable memories
Each memory: a short fact, **why** it's true, and **when/where** it was learned. Attribution lets a
later run judge whether it still holds. An unattributed "always do X" is exactly what becomes a drifted
shortcut.

### 6. Govern drift and poisoning
- **Don't over-generalize** from a single atypical interaction — one user's exception is not a global rule.
- **Re-verify against reality, not recollection** — before acting on a memory that names a file, flag,
  or API, confirm it still exists ([[source-first]]); memory reflects what was true when written.
- **Guard the write path** in autonomous runs — an agent that writes its own memory unsupervised can
  poison itself; gate or review writes the way [[autonomous-loops]] gates risky actions.

### 7. Curate: update, merge, prune
Memory is a garden, not a log. When a fact changes, **update** it; when two overlap, **merge**; when one
is proven wrong or obsolete, **delete** it. Keep an index so the store stays discoverable. A store that
only grows becomes one the agent stops trusting.

### 8. Close the loops to the right home
Route each durable thing to where it belongs: a reusable *process* → [[skill-harvest]]; a human-owned
*decision* → [[decision-docs]] (and optionally a memory pointing at it); a per-user/project *fact* →
the memory store here. Don't let everything pile into one bucket.

## Common Rationalizations

- "Remember everything, just in case." — A bloated store drifts and gets ignored; persist only durable, high-signal facts.
- "Memory and run state are the same thing." — Conflating them leaks run noise into long-term memory; keep them separate.
- "It's in memory, so it's true." — Memory is what *was* true when written; re-verify against reality before acting.
- "One global memory for everything." — Unscoped memory corrupts across users/projects; scope by identity and context.
- "Load all memory each turn so nothing's missed." — That blows the context budget; retrieve by relevance ([[context-curation]]).
- "Let the agent manage its own memory." — Unsupervised writes poison the store; gate the write path.

## Red Flags

- Secrets, transient run state, or one-off facts written to durable memory
- A single memory store shared across unrelated users/projects with no scoping
- Whole-store dumps into context instead of relevance-based retrieval
- Memories with no attribution (why/when learned) — unjudgeable later
- An agent acting on a remembered file/flag/API without confirming it still exists
- A previously-fixed bug re-introduced because memory "said" the old way was fine
- A store that only ever grows — never updated, merged, or pruned

## Verification

- [ ] Only durable, high-signal facts persisted — no secrets, run state, or one-offs
- [ ] Durable memory kept separate from single-run session state ([[long-running-agents]])
- [ ] Each memory scoped to a context/identity with governed read/write access
- [ ] Retrieval is relevance-based, not whole-store dumps ([[context-curation]])
- [ ] Memories are structured and attributed (fact + why + when/where learned)
- [ ] Drift guarded: no over-generalizing, re-verified against reality ([[source-first]]), writes gated
- [ ] Store curated — updated, merged, pruned, indexed — not append-only
- [ ] Reusable processes routed to [[skill-harvest]], human decisions to [[decision-docs]]
