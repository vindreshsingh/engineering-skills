# Testing Patterns

Supplementary patterns for writing good tests. Use alongside the [[test-first]] skill — that skill
covers *when* and *how* to drive work with tests; this is a quick pattern reference.

## Structure

- **Arrange–Act–Assert.** Set up state, perform the one action, assert the outcome. Keep the three
  phases visible.
- **One behavior per test.** A test that asserts many unrelated things tells you little when it fails.
- **Name by behavior, not method.** `redirects an unauthenticated user to login` beats `testAuth`.
- **Keep tests independent.** No shared mutable state, no ordering dependencies; each runs alone.

## What to Assert

- Observable outcomes and contracts — return values, emitted events, persisted state, responses.
- Not implementation details — private fields, internal call counts, mock wiring. Those break on
  refactor and protect nothing.

## Coverage to Aim For

- Happy path.
- Boundaries: empty, null/undefined, zero, one, max, off-by-one.
- Error paths: invalid input, failed dependency, timeout, permission denied.
- Concurrency/ordering where relevant.

## Test Doubles

- Use the lightest double that works: a real object > a fake > a stub > a mock.
- Mock at architectural seams (network, clock, filesystem), not internal collaborators.
- Don't mock the thing under test; you'll only assert your own assumptions.

## Reliability

- Deterministic by default — inject the clock and randomness, don't sleep on real time.
- No real network in unit tests; isolate integration tests that need it.
- A flaky test is a broken test: fix the root cause or quarantine it, never paper over it with retries.

## Anti-patterns

- Tests written only after the code, rubber-stamping current behavior.
- Assertions so loose they can't fail (`expect(result).toBeDefined()` as the only check).
- Giant setup shared across unrelated tests.
- Snapshot tests of large blobs that everyone updates without reading.
