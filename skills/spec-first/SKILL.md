---
name: spec-first
description: Writes a short specification before any implementation. Use when starting a new project, feature, or non-trivial change, or whenever requirements are vague, ambiguous, or exist only as a one-line idea.
---

# Spec First

Decide *what* and *why* on paper before writing *how* in code. A spec is a cheap place to be wrong —
changing a paragraph costs minutes, changing shipped code costs days.

## When to Use

- A new project, feature, endpoint, or schema change
- The request is a vague sentence ("add notifications", "make it faster")
- More than one reasonable interpretation of the requirement exists
- The change touches several modules or other people's code
- You are about to estimate, break down, or hand the work to someone else

Skip it for genuinely trivial edits (a typo, a copy tweak, a one-line bug fix).

## Process

1. **Restate the goal in one sentence.** If you cannot, you do not understand the request yet — ask.
2. **Capture the problem, not the solution.** Who has the pain, what they do today, why it hurts.
3. **List the requirements** as testable statements ("a logged-out user is redirected to /login").
   Separate must-haves from nice-to-haves.
4. **Name what is explicitly out of scope.** Scope creep starts with unstated assumptions.
5. **Sketch the approach** at a high level — data shape, key interfaces, third-party pieces — without
   pseudo-coding the whole thing.
6. **Write down open questions and risks**, and how you'll resolve each.
7. **Define done:** the observable conditions that prove the feature works.
8. **Get a second read** if the change is significant, then implement against the spec.

Keep it short — a page is usually enough. A spec nobody reads is waste.

## Common Rationalizations

- "It's faster to just code it." — Faster to start, slower to finish, when you build the wrong thing.
- "The requirements are obvious." — Then writing them down takes two minutes and costs nothing.
- "Specs go stale." — A living spec is updated as decisions change; a missing spec just hides them.
- "I'll document it after." — After-the-fact docs describe what you built, not what was needed.

## Red Flags

- You cannot state the goal in one sentence
- "We'll figure out the edge cases as we go"
- Requirements that are adjectives ("fast", "clean", "intuitive") with no measurable meaning
- Two engineers describe the feature differently
- Implementation has started and scope is still being debated

## Verification

- [ ] Goal stated in one sentence
- [ ] Requirements are concrete and testable; must vs. nice-to-have separated
- [ ] Out-of-scope list exists
- [ ] Open questions are answered or explicitly deferred with an owner
- [ ] "Done" is defined as observable conditions
- [ ] The spec is short enough that people will actually read it
