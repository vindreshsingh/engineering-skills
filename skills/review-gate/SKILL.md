---
name: review-gate
description: Reviews a change across correctness, design, readability, security, and performance before it merges. Use when reviewing a PR or your own diff prior to shipping.
---

# Review Gate

A review is the last cheap chance to catch a problem before it reaches users. Read the change with
intent across a few fixed dimensions, and judge it against what it's supposed to do — not just whether
it looks plausible.

## When to Use

- Reviewing a pull request
- Self-reviewing your own diff before opening or merging it
- Sanity-checking an AI-generated change before accepting it

## Process

Read the diff against the stated goal, then pass it through five lenses:

1. **Correctness.** Does it do what the spec/PR says? Walk the edge cases, error paths, and
   concurrency. Are there tests, and do they assert behavior that matters?
2. **Design.** Does it fit the existing architecture, or bolt on a parallel way of doing things? Right
   layer, right boundaries, no needless coupling.
3. **Readability.** Will someone understand this in six months? Clear names, manageable functions,
   comments that explain *why*. Confusion now is a bug later.
4. **Security.** Untrusted input validated, authz checks present, no secrets or injection, safe
   defaults (see [[hardening]]).
5. **Performance.** Any N+1s, accidental O(n²), unbounded growth, or blocking calls on hot paths
   (see [[perf-budget]]) — but don't demand premature optimization.

Then: prioritize findings (blocking vs. nice-to-have), be specific and kind, and suggest the fix, not
just the flaw. Approve when it's correct and safe — not when it's perfect.

## Common Rationalizations

- "It looks fine." — Looking fine isn't reading for edge cases, security, and design.
- "The author knows best." — Review exists precisely to catch what the author can't see.
- "Tests pass, so ship it." — Tests check what they check; review checks what tests miss.
- "I'll nitpick everything." — Drowning blocking issues in style nits helps no one; separate the two.

## Red Flags

- Approving a large diff in seconds
- Comments only about formatting, none about behavior or design
- No check of error paths or untrusted input
- "LGTM" with no evidence the change was actually run or reasoned about
- Blocking and trivial feedback mixed together with no priority

## Verification

- [ ] Change checked against its stated goal
- [ ] All five lenses applied (correctness, design, readability, security, performance)
- [ ] Edge cases, error paths, and untrusted input considered
- [ ] Findings prioritized; blocking issues distinguished from nits
- [ ] Feedback is specific and proposes a direction
