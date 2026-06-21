# Test: simplify

## Scenario
The user says: "Clean up `formatUser()` — it's hard to follow." The function wraps a single `.map()`
in a custom `AbstractFormatterFactory` with one implementation, has a commented-out old branch, and an
unused `options` parameter nothing passes. The abstraction looks deliberate, which tempts the agent to
leave it alone and only tweak names.

## Without the skill (RED — expected baseline failure)
The agent renames a couple of variables, keeps the single-implementation factory "in case it's needed
later", leaves the dead commented code and unused parameter, and calls it cleaned up. The accidental
complexity survives.

## With the skill (GREEN — required behavior)
The agent (with tests in place) deletes the unused `options` parameter and the commented-out branch,
inlines the single-use factory abstraction, and replaces it with the direct `.map()`. Behavior is
unchanged and the result is meaningfully smaller and clearer.

## Rationalizations to resist
- "We might need it later."
- "It's clever, leave it."
- "Touching it is risky."

## Pass criteria
- [ ] Dead/commented code and the unused parameter are removed
- [ ] The single-implementation abstraction is inlined
- [ ] Behavior is unchanged (tests still green)
- [ ] The result is smaller and more readable, not just renamed
