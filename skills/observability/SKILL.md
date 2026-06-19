---
name: observability
description: Makes a system answer questions about its own behavior in production via logs, metrics, and traces. Use when building a service, adding a feature that runs in production, or when an outage was hard to diagnose because you were flying blind.
---

# Observability

You can't operate what you can't see. Observability is the ability to ask new questions about a running
system without shipping new code — through structured logs, metrics, and traces. Build it in as you
write the feature, not after the first outage.

## When to Use

- Building or changing a service, job, or endpoint that runs in production
- Adding a feature whose health you'll need to judge after release ([[launch-readiness]])
- An incident took too long to diagnose because the signals weren't there
- Setting up monitoring/alerting for a system

## Process

1. **Decide what "healthy" means** for this component — the few signals that actually indicate user
   impact (latency, error rate, throughput, saturation). Instrument those first.
2. **Emit structured logs**, not prose. Key-value/JSON with a consistent schema, a correlation/request
   id, and enough context to act — never log secrets or PII ([[hardening]]).
3. **Use levels deliberately.** Error = needs attention; warn = suspicious; info = milestones; debug =
   diagnostic. If everything is error, nothing is.
4. **Add metrics for rates, durations, and counts** at the boundaries that matter; prefer a few
   meaningful metrics over a dashboard of noise.
5. **Propagate trace/correlation ids** across service hops so a single request can be followed
   end-to-end.
6. **Alert on symptoms, not causes.** Page on user-visible impact (error budget burn, latency SLO
   breach), with a threshold that's actionable — not on every blip.
7. **Verify the telemetry before you rely on it** — trigger the error path and confirm it shows up.

## Common Rationalizations

- "We'll add logging when something breaks." — During an incident is the worst time to discover you have no signal.
- "More logs are safer." — Noise buries the line that matters and costs money; log with intent.
- "A dashboard covers it." — A dashboard nobody alerts on won't wake anyone when it counts.
- "We'll know if it's down." — Without instrumented symptoms, you'll learn from users, late.

## Red Flags

- Diagnosing production by adding `print` statements and redeploying
- Unstructured logs you can't filter or correlate
- Secrets or PII in log output
- Alerts that fire constantly and are routinely ignored
- No way to trace one request across services
- "Healthy" is undefined, so no alert can be meaningful

## Verification

- [ ] Key health signals (latency, errors, throughput, saturation) are instrumented
- [ ] Logs are structured, leveled, correlation-id'd, and free of secrets/PII
- [ ] Metrics cover the boundaries that matter, without noise
- [ ] Requests can be traced across service hops
- [ ] Alerts fire on actionable, user-visible symptoms — and were tested
