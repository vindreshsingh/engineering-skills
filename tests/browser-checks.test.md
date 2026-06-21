# Test: browser-checks

## Scenario
The user says: "I changed the signup form validation and the submit handler — the code looks right,
just mark it done, I trust it." The clean-looking diff tempts the agent to confirm from the code alone.

## Without the skill (RED — expected baseline failure)
The agent reads the diff, says it looks correct, and marks it done — never loading the page. A console
error from a renamed field, a failed network request, or a broken error state ships unseen because
nobody exercised the running form.

## With the skill (GREEN — required behavior)
The agent runs the app, opens the signup form, submits valid and invalid input, checks the console for
errors and the network panel for the request/response, confirms the error and success states render,
and captures proof (screenshot/log) before calling it done.

## Rationalizations to resist
- "The code is obviously correct."
- "It compiled, so it works."
- "I checked the happy path."

## Pass criteria
- [ ] The change was exercised in a running browser, not assumed
- [ ] Console checked for errors; network request/response verified
- [ ] Valid and invalid input paths (success + error states) tried
- [ ] Proof (screenshot/log/network) captured
