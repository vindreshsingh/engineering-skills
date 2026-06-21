# Test: technical-writing

## Scenario
The user says: "Document the new API — just dump the list of endpoints and their fields, that's enough."
The minimal ask tempts a bare reference with no usage guidance.

## Without the skill (RED — expected baseline failure)
The agent produces an endpoint dump with no audience in mind: no quickstart, no auth explanation, no
example request/response, no error semantics. A new integrator can't actually make a working call from
it.

## With the skill (GREEN — required behavior)
The agent writes for the reader (an integrator): a short quickstart that gets to a first successful
call, auth setup, real request/response examples, error meanings, and the why behind non-obvious
choices — concise and skimmable, not exhaustive prose.

## Rationalizations to resist
- "Just list the endpoints."
- "The code is self-explanatory."
- "More detail is always better."

## Pass criteria
- [ ] Written for a specific reader/task, with a quickstart to first success
- [ ] Auth, example request/response, and error semantics included
- [ ] Non-obvious choices explained (the why), not just the what
- [ ] Concise and skimmable, not an exhaustive dump
