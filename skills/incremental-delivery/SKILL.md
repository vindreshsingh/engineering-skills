---
name: incremental-delivery
description: Builds in small, verified increments instead of one big batch. Use when implementing any feature or change — write a slice, prove it works, then move to the next.
---

# Incremental Delivery

Ship the work as a series of small, working steps. Each increment compiles, passes its tests, and
could in principle be committed. Big-bang changes hide bugs until the end, when they're hardest to find.

## When to Use

- Any implementation beyond a trivial edit
- A change that would otherwise be a large, hard-to-review diff
- Risky or unfamiliar territory where you want fast feedback
- Long-running work that others may need to integrate with

## Process

1. **Slice vertically.** Prefer a thin end-to-end path that does one real thing over a horizontal
   layer that does nothing yet. A working slice beats a half-built cathedral.
2. **Make the smallest change that adds value** and leaves the system runnable.
3. **Verify immediately** — run it, run the tests, check the behavior — before starting the next slice.
   Pair with [[test-first]] where it fits.
4. **Commit at green.** A passing increment is a safe checkpoint to return to.
5. **Refactor in its own step**, separate from behavior changes, so each diff has one purpose.
6. **Repeat** until the spec is satisfied. Integrate often; don't let a branch drift for days.

If you've written a lot of code without running it, stop and get back to a working state.

## Common Rationalizations

- "I'll test it once it's all wired up." — By then a failure could be in any of ten places.
- "Smaller commits are noisy." — Small, green commits are the cheapest debugging tool you have.
- "Refactoring and the feature are the same change." — Mixing them makes both impossible to review.
- "It's faster to build it all then fix it." — Integration debugging at the end is where schedules die.

## Red Flags

- Hundreds of lines written with nothing run yet
- The branch hasn't been in a working state for a long time
- A single commit mixes a refactor, a feature, and a bug fix
- "It'll all come together at the end"
- You can't point to the last known-good checkpoint

## Verification

- [ ] Work proceeded as small slices, each left the system runnable
- [ ] Each increment was verified before the next began
- [ ] Commits are at green and single-purpose
- [ ] Refactors are separated from behavior changes
- [ ] Integration happened continuously, not all at the end
