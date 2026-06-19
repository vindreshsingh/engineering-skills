---
name: context-curation
description: Manages what information an AI agent works from so its context stays relevant and small. Use when a task spans many files, when responses drift or hallucinate, or when setting up an agent's working set.
---

# Context Curation

An agent is only as good as what's in its context window. Too little and it guesses; too much and the
signal drowns in noise. Curate deliberately: load what the current step needs, and nothing else.

## When to Use

- A task touches a large codebase and you must choose what to show the agent
- Responses are drifting, repeating, or inventing files/APIs that don't exist
- You're writing project rules, a CLAUDE.md, or an agent's standing instructions
- A long session is degrading in quality as it fills up

## Process

1. **Define the task's working set** — the specific files, contracts, and facts this step depends on.
   Resist loading "everything related just in case."
2. **Prefer authoritative sources.** Point the agent at the real code, types, and docs rather than
   your paraphrase of them (see [[source-first]]).
3. **Front-load durable rules, lazy-load details.** Standing conventions belong in project memory;
   task-specific detail should be pulled in only when that task is active.
4. **Summarize and prune as you go.** When a sub-task is finished, collapse its detail to a short
   conclusion so the window holds outcomes, not transcripts.
5. **Re-anchor on long tasks.** Periodically restate the goal and current state so later steps don't
   drift from the original intent.
6. **Keep instructions specific and non-contradictory.** Conflicting guidance wastes tokens and
   produces hedging.

## Common Rationalizations

- "More context is safer." — Past a point, extra context lowers accuracy and hides the relevant bits.
- "I'll paste the whole file." — Show the function that matters; the rest is noise the model must wade through.
- "It remembers what we discussed." — Detail decays as the window fills; re-anchor the essentials.
- "One big rules file covers it." — Rules that contradict or over-specify confuse more than they help.

## Red Flags

- Dumping entire directories into context "for completeness"
- The agent references files or functions that don't exist
- Quality dropping as the session grows long
- Standing instructions that contradict each other
- The same context re-explained repeatedly instead of summarized once

## Verification

- [ ] Only task-relevant material is loaded for the current step
- [ ] The agent works from real sources, not paraphrases
- [ ] Durable rules live in memory; task detail is loaded on demand
- [ ] Finished sub-tasks are summarized down to conclusions
- [ ] Goal and state are re-anchored on long tasks
