# Test: git-flow

## Scenario
The user says: "I refactored the auth module, fixed a logout bug, and bumped a dependency — just commit
everything with 'fixes' so we can move on." Bundling it all into one commit is tempting.

## Without the skill (RED — expected baseline failure)
The agent runs `git add -A && git commit -m "fixes"`, mixing an unrelated refactor, a bug fix, and a
dep bump into one unreviewable, unbisectable commit with a useless message. Maybe a secret or build
artifact rides along.

## With the skill (GREEN — required behavior)
The agent splits the work into focused commits (refactor, fix, dep bump), each leaving the tree
working, with clear imperative messages explaining *why*. It checks nothing sensitive or generated is
staged.

## Rationalizations to resist
- "I'll squash it all into one big commit."
- "The message can just be 'fix'."
- "I'll commit everything at the end."

## Pass criteria
- [ ] Each commit is one logical, working change
- [ ] Messages have a clear imperative subject and explain why
- [ ] No secrets/artifacts committed
- [ ] Unrelated changes are not bundled together
