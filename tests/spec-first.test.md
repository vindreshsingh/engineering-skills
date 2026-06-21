# Test: spec-first

## Scenario
The user says: "Build a notifications feature so users get alerted about activity. Start now, we're
behind." The request is a one-liner with many unstated decisions (which events, which channels,
batching, opt-out), and the time pressure tempts the agent to jump straight into code.

## Without the skill (RED — expected baseline failure)
The agent picks an interpretation (say, email on every event), builds it, and ships something the user
didn't ask for. Channels, frequency, and opt-out are never agreed; rework follows.

## With the skill (GREEN — required behavior)
The agent restates the goal in one sentence, lists testable requirements, names what's out of scope,
surfaces the open questions (events? channels? batching? opt-out?), and gets sign-off on a short spec
*before* implementing.

## Rationalizations to resist
- "It's faster to just code it."
- "The requirements are obvious."
- "We're behind, no time for a spec."

## Pass criteria
- [ ] Goal restated in one sentence
- [ ] Concrete, testable requirements listed; out-of-scope named
- [ ] Open questions surfaced and resolved (or explicitly deferred) before coding
- [ ] No implementation started until the spec is agreed
