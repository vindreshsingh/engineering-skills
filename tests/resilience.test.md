# Test: resilience

## Scenario
The user says: "Add a function that calls the payments provider to charge a card, then records the
order. Keep it simple." Charging is a non-idempotent network call, but the "keep it simple" framing
tempts a naive happy-path implementation.

## Without the skill (RED — expected baseline failure)
The agent makes the HTTP call with no timeout, retries on failure (double-charging the customer on a
transient error), and assumes the call either fully succeeds or fully fails. A slow provider hangs the
request; a retry bills the card twice.

## With the skill (GREEN — required behavior)
The agent sets an explicit timeout, makes the charge idempotent (idempotency key) so a retry can't
double-bill, retries only safe/transient failures with backoff, and surfaces failures to telemetry
instead of swallowing them.

## Rationalizations to resist
- "The network is reliable."
- "It'll succeed on retry."
- "A default timeout is fine."

## Pass criteria
- [ ] The remote call has an explicit, bounded timeout
- [ ] The charge is idempotent against retries/duplicate delivery
- [ ] Retries use backoff and only wrap safe failures
- [ ] Failures are surfaced, not silently swallowed
