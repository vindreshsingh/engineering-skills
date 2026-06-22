---
name: autonomous-loops
description: Designs and supervises an autonomous agent loop (a /goal- or /loop-style run that prompts itself until a verifiable stop) so it ships work you can trust instead of accumulating silent errors. Use when setting up an agent to run unattended, on a schedule, or in a self-prompting cycle — and to decide when NOT to loop.
---

# Autonomous Loops

A loop is an agent that prompts *itself* — selecting the next task, doing it, checking it, logging
progress, repeating — until a stop condition is met. Done well it multiplies throughput; done badly it
manufactures **comprehension debt** (code nobody reviewed) and invites **cognitive surrender**
(accepting output without thinking). The job of this skill is to build loops that stay accountable: a
verifiable stop, a checker separate from the maker, a place for decisions that need a human, and hard
caps on spend — with **you still the engineer who confirms it works**, not the person who pressed go.

This is the autonomy conductor. It composes [[parallel-subagents]] (fan-out), [[long-running-agents]]
(multi-hour coherence), and [[agent-verification]] (trustworthy "done"); it does not replace them. It
sits under [[agent-guardrails]] — autonomy never widens what an agent may do without approval.

## When to Use

- Setting up an agent to run **unattended** or on a **schedule** (discovery, triage, recurring fixes)
- Building a **self-prompting cycle** (`/goal` until a stop condition; `/loop` on a cadence)
- A backlog of similar, well-specified tasks an agent could grind through
- You want automation to *surface* decisions, not *make* irreversible ones

**Skip / don't loop when:**
- The task is **one-off** or ambiguous — direct prompting is still the right tool; don't loop for its own sake
- Success **can't be verified programmatically** — without a checkable stop, a loop just drifts confidently
- The work is **high-blast-radius** (prod data, money, security, irreversible) — keep a human in the turn
- You'd be unable to **review the output volume** the loop produces — that's comprehension debt by design

**Not a substitute for** your judgment: a loop is a tool built *with* critical thinking, not a way to
avoid it.

## Process

### 1. Write a verifiable stop condition first
Before any loop runs, define **done** as something a machine can check — tests green, a metric met, an
empty queue, a checklist all-passed ([[agent-verification]] owns the check). "Until it looks done" is
not a stop condition; it's an open tab burning tokens. No verifiable stop → don't loop.

### 2. Split maker from checker
The agent that *does* the work must not be the only one that *judges* it — models grade themselves too
generously. Route each iteration's output through a separate evaluator (a sub-agent, ideally a
different model) per [[agent-verification]]. The checker can **refuse** and send work back.

### 3. Bound the blast radius
- Run in isolation — git worktree / branch, sandbox — and integrate via **pull request**, never direct
  pushes to a protected branch ([[git-flow]]).
- Keep [[agent-guardrails]] active: destructive/secret/prod actions still require explicit approval,
  loop or not.

### 4. Add circuit breakers
Set explicit caps **before** starting: max iterations, wall-clock limit, and a **token/cost ceiling**
([[finops-budget]] for spend). On breach, stop and surface — a runaway loop is a budget incident.

### 5. Route human decisions to a triage inbox
Anything the loop *shouldn't* decide — ambiguous trade-offs, risky changes, judgment calls — goes to a
single **triage inbox** (an issue list, a Linear board, a `TRIAGE.md`) for a human, instead of the
agent guessing. Confident guessing on missing intent is **intent debt**; make the loop ask, not assume.

### 6. Make progress durable and resumable
Each iteration commits a meaningful unit and updates an external progress/plan file so a reset or crash
can resume without redoing work ([[long-running-agents]] owns the mechanics).

### 7. Supervise — stay the verifier
Sample the loop's output continuously; don't wait for the end. **Your job is to ship code you
confirmed works.** If you find yourself rubber-stamping, that's cognitive surrender — slow the loop,
shrink the batch, or stop it.

### 8. Know when to stop the loop
Stop when the stop condition is met, a circuit breaker trips, the triage inbox is backing up, or the
checker's reject rate climbs (the loop is thrashing). Then review the batch as a human before merge.

## Common Rationalizations

- "It's autonomous, I don't need to review it." — Then you're shipping unreviewed code; that's comprehension debt, and it's yours when it breaks.
- "The agent said it's done." — Self-grading is biased; a separate checker decides done ([[agent-verification]]).
- "I'll set a budget later." — Later is after the runaway bill; caps go in before the first iteration.
- "Loop everything to save time." — Direct prompting still wins for one-off or fuzzy work; looping those wastes tokens and trust.
- "The agent can decide that edge case." — If it needs judgment, it goes to triage; confident guesses become intent debt.
- "I'll just press go and check at the end." — Sampling continuously catches drift while it's cheap.

## Red Flags

- A loop with no machine-checkable stop condition
- The maker and the checker are the same agent (or same model grading itself)
- No iteration / time / token ceiling set
- Direct commits to a protected branch instead of PRs from isolation
- No triage inbox — the agent guesses on ambiguity instead of asking
- Output volume exceeds what any human will actually review
- Reject rate climbing while the loop keeps running (thrashing)

## Verification

- [ ] A verifiable, machine-checkable stop condition was written before the loop ran
- [ ] Maker and checker are separate (ideally different models); the checker can reject ([[agent-verification]])
- [ ] Loop runs in isolation and integrates via PR; [[agent-guardrails]] still gate risky actions
- [ ] Iteration, wall-clock, and token/cost circuit breakers set ([[finops-budget]])
- [ ] A triage inbox exists for decisions the loop must not make
- [ ] Progress is committed and resumable each iteration ([[long-running-agents]])
- [ ] A human sampled output during the run and reviewed the batch before merge — not rubber-stamped
