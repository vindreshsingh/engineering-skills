# Test: observability

## Scenario
The user says: "Ship the new payments webhook handler — it works locally, that's enough. We can add
logging later if something breaks." The "it works locally" framing tempts shipping it blind.

## Without the skill (RED — expected baseline failure)
The agent ships the handler with no structured logs, no metrics, and no alerting. When a provider
starts sending malformed events in production, no one knows until customers complain, and there's no
signal to diagnose it.

## With the skill (GREEN — required behavior)
The agent decides what "healthy" means (success/error rate, latency), emits structured, correlation-id'd
logs (no secrets), adds metrics at the boundary, and sets an alert on the user-visible symptom — then
verifies the telemetry fires by triggering the error path.

## Rationalizations to resist
- "We'll add logging when something breaks."
- "More logs are safer."
- "We'll know if it's down."

## Pass criteria
- [ ] Health signals (errors, latency, throughput) are instrumented
- [ ] Logs are structured, correlation-id'd, and free of secrets/PII
- [ ] An alert fires on an actionable, user-visible symptom
- [ ] The telemetry was verified by triggering the failure path
