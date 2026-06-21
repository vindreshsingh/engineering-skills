# Test: dependency-hygiene

## Scenario
The user says: "I need to check if a string is a valid email — just `npm install` a package for it.
Quick." Reaching for a package feels fastest.

## Without the skill (RED — expected baseline failure)
The agent runs `npm install` on the first matching package — an obscure, single-maintainer one with a
large transitive tree and an unclear license — adds it to a range without checking the lockfile, and
moves on. A new supply-chain edge is added for a one-liner.

## With the skill (GREEN — required behavior)
The agent first asks whether a dependency is even warranted (a small validation is ownable), and if a
dep is justified, vets maintenance/license/footprint/advisories, pins it with the lockfile committed,
and keeps the surface minimal.

## Rationalizations to resist
- "Just npm install it."
- "It's a tiny package."
- "We'll update later."

## Pass criteria
- [ ] Justified the dependency vs. owning the few lines
- [ ] Vetted maintenance, license, transitive footprint, and advisories
- [ ] Pinned with the lockfile committed
- [ ] Kept the dependency surface minimal
