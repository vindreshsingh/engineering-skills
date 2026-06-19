---
name: fault-recovery
description: A disciplined method for debugging and recovering from failures. Use when something breaks, behaves unexpectedly, a test fails, or an error appears — instead of guessing at fixes.
---

# Fault Recovery

Debug by narrowing, not by guessing. Reproduce the failure, find the smallest case that triggers it,
form a hypothesis, and test one change at a time. Random edits hide bugs more often than they fix them.

## When to Use

- A crash, exception, failing test, or wrong output
- Behavior that contradicts what the code should do
- A regression after a change
- Flaky or intermittent failures

## Process

1. **Reproduce it reliably.** A bug you can't trigger on demand, you can't confirm you fixed. Pin down
   the exact inputs and conditions.
2. **Read the actual error.** The message, stack trace, and logs usually name the place — read them
   fully before theorizing.
3. **Narrow the surface.** Bisect: by code (recent changes, `git bisect`), by input (shrink to the
   minimal failing case), or by component (disable parts until it stops).
4. **Form one hypothesis** about the cause that explains the evidence.
5. **Test it with a single change.** Change one thing, observe, keep notes. Don't shotgun multiple edits.
6. **Confirm with the source.** Verify the real behavior of the suspect code/API (see [[source-first]])
   rather than trusting your model of it.
7. **Fix the cause, not the symptom**, then lock it in with a regression test ([[test-first]]).
8. **If stuck, widen the lens** — check assumptions, environment, versions, and data, not just the code.

## Common Rationalizations

- "I'll just try a few things." — Untracked random changes create new bugs and hide the real one.
- "I don't need to reproduce it." — Then you can't prove the fix worked.
- "The error message is generic." — It still points somewhere; read the whole trace and logs.
- "It's probably a fluke." — Intermittent bugs are real bugs with a condition you haven't found yet.

## Red Flags

- Changing code before reproducing the failure
- Multiple simultaneous edits with no idea which one mattered
- Skimming past the stack trace to start guessing
- "Fixing" by masking the symptom (catch-and-ignore, retry-until-pass)
- A fix with no test to stop the bug from returning

## Verification

- [ ] The failure was reproduced reliably before and after the fix
- [ ] The error/trace/logs were actually read
- [ ] The cause was isolated by narrowing, not guessing
- [ ] One change tested at a time
- [ ] Root cause fixed (not just the symptom) and guarded by a regression test
