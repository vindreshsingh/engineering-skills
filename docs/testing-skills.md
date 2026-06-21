# Testing Skills Behaviorally

A skill is only real if it **changes what an agent does**. Structural validation (frontmatter,
sections) proves a skill is well-formed; it does not prove the skill *works*. This is how we prove it.

The method is test-driven, applied to process documentation:

> **RED** — give an agent the pressure scenario *without* the skill, and watch it cut the corner.
> **GREEN** — give it the same scenario *with* the skill, and confirm it holds the line.
> **REFACTOR** — find the rationalization it used to escape, and close that loophole in the skill.

If you never watched an agent fail without the skill, you don't know the skill teaches the right thing.

## Why this is the bar

Anyone can write a markdown file full of good advice. The hard question is: under pressure — a
deadline, a "just this once," an easier path — does the agent actually follow it? A skill that doesn't
survive that pressure is decoration. Behavioral tests are how we keep every skill honest.

## Anatomy of a skill test

Each skill has a test file at `tests/<skill-name>.test.md` with this structure:

```markdown
# Test: <skill-name>

## Scenario
A realistic task that tempts the agent to skip the skill's process. Include the pressure
(time, "obviousness", an easier path) that makes cutting the corner attractive.

## Without the skill (RED — expected baseline failure)
What an agent typically does here when the skill is NOT loaded — the corner it cuts.

## With the skill (GREEN — required behavior)
The specific, observable actions the agent MUST take when the skill IS loaded.
Phrase as checkable assertions.

## Rationalizations to resist
The exact excuses an agent uses to escape the process. Each must be addressed by the
skill's "Common Rationalizations" section.

## Pass criteria
- [ ] Bullet list of observable conditions that mean the skill held.
```

## Running the tests

```bash
bash scripts/skill-test.sh            # validate every test file's structure + show coverage
bash scripts/skill-test.sh --coverage # just the coverage report (which skills lack a test)
```

The structural runner checks that test files are well-formed and that their **Rationalizations** are
actually covered by the skill's `Common Rationalizations` section — a cheap, automatable proxy for the
full RED/GREEN loop. The *behavioral* run (dispatching an agent against the scenario) is done by a
human or an orchestrating agent using [[skill-creator]]; record the result in the test file's history.

## How to add a test (the loop)

1. Pick the corner the skill exists to prevent.
2. Write the **Scenario** so that corner is tempting.
3. Run the scenario against an agent **without** the skill — record the failure and the exact
   rationalizations it used (RED).
4. Ensure the skill addresses every one of those rationalizations.
5. Run it **with** the skill — confirm the pass criteria (GREEN).
6. If it still escapes, tighten the skill and repeat (REFACTOR).

This is `skill-creator` made measurable. A skill without a passing test is a draft.
