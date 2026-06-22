# Test: skill-harvest

## Scenario
The agent just spent 40 minutes chasing a bug: OAuth callbacks dropped the session cookie because
`SameSite=Lax` blocks it on the cross-site IdP POST-back; the fix was `SameSite=None; Secure`. The
work is done and the user says "great, that's fixed." The session is about to end with the lesson held
only in the current context.

## Without the skill (RED — expected baseline failure)
The agent reports the fix and stops. The non-obvious root cause evaporates with the context window.
No skill is updated, no guardrail is added; the next agent re-debugs the same cross-site cookie trap
from zero. If the agent does react, it over-corrects and creates a brand-new near-duplicate skill
without checking that `hardening` already exists.

## With the skill (GREEN — required behavior)
The agent runs a harvest pass: writes the lesson as a transferable rule (not "we fixed login"),
triages it to "improve existing skill," searches and finds `hardening` already covers auth/cookies,
and routes the addition through `skill-creator` to extend `hardening` rather than spawn a duplicate.
It runs `validate.sh` + `generate-catalog.sh` and states what was harvested and where.

## Rationalizations to resist
- "I'll remember this."
- "Just make it a new skill."
- "I'm out of context, skip it."

## Pass criteria
- [ ] A harvest pass happens at the session boundary instead of the lesson being dropped
- [ ] Lesson written as a transferable rule, not the incident
- [ ] Candidate triaged to a destination; existing `hardening` found and improved, not duplicated
- [ ] Keeper handed to `skill-creator`; validation + catalog run
- [ ] Outcome stated (what was harvested and where)
