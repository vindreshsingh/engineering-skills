---
name: test-first
description: Drives changes with tests that capture intended behavior before the code exists. Use when implementing logic, fixing a bug, or changing behavior, and when you need to prove the code works.
---

# Test First

Write the test that describes the behavior you want, watch it fail, then write the code that makes it
pass. A test written before the code tests the requirement; a test written after tends to test
whatever the code happens to do.

## When to Use

- Implementing any non-trivial logic or behavior
- Fixing a bug — reproduce it as a failing test first, so it can never silently return
- Changing existing behavior — pin the new contract with a test
- Anywhere correctness matters more than a throwaway spike

## Process

1. **Pick one behavior** small enough to express in a single test.
2. **Write the test** against the public interface, asserting the observable outcome — not internal
   details. Name it after the behavior ("returns 401 when the token is expired").
3. **Run it and watch it fail** for the right reason. A test that passes before you write code proves
   nothing.
4. **Write the minimum code** to make it pass.
5. **Refactor** with the test as your safety net.
6. **Repeat** for the next behavior, including the edge and error cases.

For bugs: failing test that reproduces it → fix → test goes green → it stays a regression guard.

Test behavior and contracts, not implementation. Tests coupled to internals break on every refactor
and stop being worth keeping.

## Common Rationalizations

- "I'll add tests after it works." — Post-hoc tests rubber-stamp the current behavior, bugs included.
- "This is too simple to test." — Simple code with a test costs little; simple code that breaks costs more.
- "Tests slow me down." — They slow the first commit and speed up every change after it.
- "I tested it manually." — Manual checks aren't repeatable and don't catch tomorrow's regression.

## Red Flags

- Tests written only after the feature is "done"
- A test that passed the first time you ran it
- Assertions on private fields, call order, or mock internals instead of outcomes
- A bug fixed with no test reproducing it
- Skipped/commented-out tests accumulating

## Verification

- [ ] Each behavior had a failing test before its code existed
- [ ] Every fixed bug has a regression test
- [ ] Tests assert observable behavior, not implementation details
- [ ] Edge and error cases are covered, not just the happy path
- [ ] The suite runs green and nothing is skipped to make it pass
