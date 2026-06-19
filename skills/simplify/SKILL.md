---
name: simplify
description: Removes accidental complexity — dead code, duplication, needless indirection, over-engineering. Use when refactoring, after a feature lands, or when code is harder to read than the problem warrants.
---

# Simplify

The goal is the simplest code that correctly solves the actual problem. Most complexity is accidental:
abstractions built for futures that never arrived, duplication, and indirection that hides intent.
Delete it, don't decorate it.

## When to Use

- Cleaning up after a feature lands or a spike becomes real code
- Code that takes more effort to read than the problem deserves
- A reviewer or you keep getting lost following the flow
- Before extending a messy area — simplify first, then add

This skill is about clarity and reuse, not hunting bugs (that's [[review-gate]] / [[fault-recovery]]).

## Process

1. **Understand it fully first.** You can't safely simplify what you don't understand. Tests give you
   the net to refactor under ([[test-first]]).
2. **Delete what isn't used.** Dead code, unreachable branches, unused params, commented-out blocks,
   speculative options nobody calls.
3. **Remove duplication** by extracting the shared idea — but only once the duplication is real, not
   coincidental.
4. **Collapse needless indirection.** A wrapper, layer, or abstraction with a single caller and no
   real seam is usually noise; inline it.
5. **Replace clever with clear.** Prefer the obvious construct over the terse trick; name things for
   what they mean.
6. **Reduce state and moving parts.** Fewer mutable variables, flags, and special cases.
7. **Refactor in small, behavior-preserving steps**, re-running tests between each.

Don't add abstraction for an imagined future — solve the problem in front of you.

## Common Rationalizations

- "We might need it later." — Add it later, when "later" is real; YAGNI beats speculative flexibility.
- "It's clever, leave it." — Clever code is read many times and cursed each time; clear wins.
- "Touching it is risky." — With tests in place, the bigger risk is leaving the maze for the next person.
- "It works, don't refactor." — Working but unreadable code is a future bug waiting for a hurried edit.

## Red Flags

- Abstractions with exactly one implementation or caller
- The same logic copy-pasted in several places
- Layers that just pass calls through unchanged
- Functions you have to re-read three times to follow
- Flags and config options nothing sets
- "Flexible" frameworks built for requirements that don't exist

## Verification

- [ ] Behavior is unchanged — tests still green
- [ ] Dead code, unused params, and duplication removed
- [ ] Single-use indirection inlined; layers earn their keep
- [ ] Clearer names and constructs replace clever ones
- [ ] No speculative abstraction added; the result is smaller and easier to read
