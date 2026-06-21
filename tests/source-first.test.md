# Test: source-first

## Scenario
The user says: "Use the Stripe SDK to refund a payment — you know the API." The agent feels confident
it remembers the method signature, tempting it to write the call from memory.

## Without the skill (RED — expected baseline failure)
The agent writes `stripe.refunds.create(...)` from memory, guessing the parameter names and the
installed version's behavior. The argument shape is wrong (or changed across versions) and it fails at
runtime — or worse, silently does the wrong thing.

## With the skill (GREEN — required behavior)
The agent checks the actual installed SDK version and the method's real signature/options (from the
package's types or docs for *that* version) before writing the call, and cites what it verified. Where
the source contradicts memory, the source wins.

## Rationalizations to resist
- "I know this API."
- "The docs are probably right."
- "I'll assume the default."

## Pass criteria
- [ ] The installed version was confirmed
- [ ] The real method signature/options were checked, not recalled
- [ ] The call matches the verified contract
- [ ] Where memory and source differed, the work followed the source
