---
name: incident-response
description: Handles production incidents — mitigate first, diagnose second, learn blamelessly after. Use when something is broken in production, an alert is firing, or you're running the postmortem.
---

# Incident Response

During an incident, the goal is to **stop user pain fast**, then understand why, then make sure it
can't recur. Restoring service comes before finding the root cause — and the follow-up learning
matters as much as the fix. Heroics without a process just produce the next incident.

## When to Use

- A production outage or degradation is happening now
- An alert is firing and user impact is suspected
- A recent fix needs a postmortem so it sticks
- Establishing on-call / incident practices for a team

## Process

**During the incident — mitigate first:**
1. **Assess impact and declare.** What's broken, for whom, how bad? Declare an incident and name a
   single coordinator so response isn't chaotic.
2. **Stabilize before diagnosing.** Reach for the fastest safe mitigation — roll back the recent
   deploy, flip the feature flag, fail over, shed load. You don't need root cause to stop the bleeding.
3. **Communicate.** Keep stakeholders updated on impact and ETA at a steady cadence; don't go dark.
4. **Then diagnose** with discipline ([[fault-recovery]]) using your telemetry ([[observability]]) —
   change one thing at a time even under pressure.

**After — learn:**
5. **Write a blameless postmortem:** timeline, impact, what happened, why (contributing factors, not a
   scapegoat), and how it was resolved.
6. **Produce concrete action items** with owners — the fix, the missing alert, the guardrail — and
   actually track them to done.
7. **Improve the system, not the person.** Most incidents are latent system/process gaps; harden those
   so the next person can't trip the same wire.

## Common Rationalizations

- "Let me find the root cause first." — Find it after you've stopped the user impact, not before.
- "We don't need a postmortem, we know what happened." — Undocumented lessons are relearned the hard way.
- "It was human error." — "Why was that error possible/easy?" is the real, fixable question.
- "Just this once, deploy the hotfix straight to prod." — Skipping safety mid-incident often deepens it.

## Red Flags

- Debugging root cause while users are still down and a rollback was available
- No single coordinator; several people changing things at once
- Stakeholders left in the dark during an outage
- Postmortems that assign blame instead of fixing systems
- Action items written and never done
- The same incident recurring because nothing structural changed

## Verification

- [ ] Impact assessed and an incident/coordinator declared
- [ ] Service stabilized via the fastest safe mitigation before deep diagnosis
- [ ] Stakeholders kept informed throughout
- [ ] Root cause found methodically once mitigated
- [ ] Blameless postmortem written with timeline and contributing factors
- [ ] Action items have owners and are tracked to completion
