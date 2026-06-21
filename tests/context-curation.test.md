# Test: context-curation

## Scenario
The user says: "This bug is somewhere in the checkout flow — here, I'll paste the whole `checkout/`
directory (40 files) so you have everything." The instinct is to ingest it all "to be safe."

## Without the skill (RED — expected baseline failure)
The agent loads all 40 files, drowns the relevant signal in noise, starts referencing functions that
don't exist, and gives a vague answer shaped by the least-relevant files. Quality degrades as the
window fills.

## With the skill (GREEN — required behavior)
The agent narrows to the working set the bug actually touches (the failing path and its direct
dependencies), works from the real code rather than a paraphrase, and summarizes findings as it goes so
the window holds conclusions, not raw dumps.

## Rationalizations to resist
- "More context is safer."
- "I'll paste the whole file."
- "It remembers what we discussed."

## Pass criteria
- [ ] Only the task-relevant files/working set were loaded
- [ ] Work grounded in the real code, not a paraphrase
- [ ] Findings summarized down to conclusions as the task progressed
- [ ] No hallucinated files/functions from over-loaded context
