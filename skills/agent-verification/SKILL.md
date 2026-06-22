---
name: agent-verification
description: Stops an AI agent from declaring "done" on work it hasn't actually finished, by separating generation from evaluation and refusing self-graded completion. Use whenever an agent reports a task complete — especially in autonomous or long-running runs — to catch early termination, self-grading bias, and gamed tests before the work is trusted or merged.
---

# Agent Verification

Models are optimists about their own work: they declare "task complete" with tests failing, edge cases
unhandled, or the goal only half-met — and when asked to grade themselves, they mark up. **Generation
and evaluation must be separate.** This skill is the check that makes an agent's "done" trustworthy:
an independent evaluator (ideally a different model) verifies the claim against external
done-conditions and can **refuse**, sending the work back. It's the brake that keeps
[[autonomous-loops]] and [[long-running-agents]] from shipping confident-but-wrong output.

This is verification of an *agent's completion claim*, distinct from [[review-gate]] (human reviewing a
finished diff for quality) and [[test-first]] (writing the tests). It composes both; it does not
replace them.

## When to Use

- An agent reports a task **complete** — before you trust, merge, or move on
- Inside an **autonomous loop** as the maker/checker split ([[autonomous-loops]])
- At **restart/handoff boundaries** in a long run — re-verify rather than assume prior "done"
  ([[long-running-agents]])
- A run is suspiciously fast or quiet — a likely **early termination**

**Skip** when a human has already verified the work against its acceptance criteria, or for trivial
changes a typecheck/test already gates automatically.

**Not a substitute for** [[test-first]] (the tests themselves) or [[review-gate]] (human quality
review). This skill checks the *claim of completion*; those produce and review the work.

## Process

### 1. Verify against external done-conditions, not the agent's say-so
Take the **written done-conditions** (from the spec / plan / [[long-running-agents]] files) and check
each one against reality. "I think it's done" is not evidence; a passing check against the stated
criteria is. If no done-conditions were written, that's the first failure — define them before
claiming completion.

### 2. Separate the evaluator from the generator
The checker must not be the agent that did the work. Use a **fresh sub-agent**, ideally a **different
model**, with the done-conditions and the diff — not the maker's narrative. Independence is the whole
point; a self-review re-imports the same blind spots.

### 3. Run the work, don't read it
Execute the tests, run the build, exercise the actual behavior ([[browser-checks]] / [[e2e-testing]]
where relevant). Confirm acceptance criteria pass **against the running system**, not by assertion in
prose.

### 4. Enforce the test ratchet — no gaming the check
Reject any "pass" achieved by **deleting or skipping failing tests**, weakening assertions, or
hard-coding outputs. A test suite that shrank or got more permissive to go green is a red flag, not a
success. Compare test count and coverage to the baseline.

### 5. Catch early termination
Walk the original task list: is **every** item actually done, or did the agent stop at the easy ones
and declare victory? Unfinished sub-tasks, TODOs left in code, and "out of scope" hand-waving on
in-scope work all fail verification.

### 6. Refuse and route back
If verification fails, the checker **refuses the completion claim** and returns specific, reproducible
gaps — not vibes. In a loop, that sends the iteration back to the maker; for a human run, it blocks the
merge until the gaps close.

### 7. Re-verify at boundaries
Don't trust a "done" inherited across a context reset or handoff. Re-run the check at restart so a
premature completion from an earlier turn can't slip through ([[long-running-agents]]).

## Common Rationalizations

- "The agent says the tests pass." — Then running them costs nothing and proves it; claims aren't evidence.
- "It reviewed its own work." — Self-grading is biased; an independent evaluator is the only trustworthy check.
- "Tests are green, ship it." — Green *after* deleting the failing test is gaming; ratchet the suite (step 4).
- "It's basically done." — "Basically" is early termination; walk every task-list item.
- "We verified it earlier in the run." — Long runs drift and re-introduce bugs; re-verify at the boundary.
- "Reading the diff is enough." — Read confirms intent; only running confirms behavior.

## Red Flags

- "Done" claimed with no external done-conditions to check against
- The same agent/model both produced and graded the work
- Verification by reading/asserting instead of running the tests and the system
- Test count or coverage dropped, or assertions weakened, to reach green
- Task-list items silently dropped or re-labeled out-of-scope
- A completion claim inherited across a reset and never re-checked
- The checker returns "looks good" with no executed evidence

## Verification

- [ ] Checked against written external done-conditions, not the agent's narrative
- [ ] Evaluator is independent of the generator (fresh agent, ideally a different model)
- [ ] Tests/build/behavior actually executed; acceptance criteria pass on the running system
- [ ] Test ratchet enforced — no deleted/skipped tests, weakened assertions, or hard-coded passes
- [ ] Every original task-list item confirmed done — no early termination
- [ ] On failure, the claim was refused with specific reproducible gaps and routed back
- [ ] "Done" re-verified at any reset/handoff boundary, not inherited
