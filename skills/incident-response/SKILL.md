---
name: incident-response
description: Handles production incidents — mitigate first, diagnose second, learn blamelessly after. Use when something is broken in production, an alert is firing, users are impacted, coordinating response, or running a postmortem.
---

# Incident Response

During an incident, the goal is **stop user pain fast**, then understand why, then make sure it
can't recur. Restoring service comes before root cause — heroics without a process produce the next
incident. Follow-up learning matters as much as the fix: blameless postmortems and **tracked action
items** that change systems, not scapegoats.

This skill is for **active production impact** and **post-incident learning**. For methodical debugging
once service is stable (or in dev/CI), use [[fault-recovery]]. For the signals that guide response, see
[[observability]]. For safe rollback and hotfix mechanics, see [[launch-readiness]] and [[git-flow]].

## When to Use

- Production outage or degradation **now** — errors, latency, unavailable feature
- Alert firing with suspected user impact (SLO breach, error budget burn)
- Coordinating multiple people responding to the same outage
- Writing or presenting a postmortem / RCA after an incident
- Standing up on-call, incident channels, or response conventions for a team
- After mitigation — driving root-cause work without relitigating blame

Skip as the primary skill for local dev bugs or CI failures with no production impact →
[[fault-recovery]]. Still use postmortem discipline if a near-miss was production-adjacent.

**Not this skill alone:** deep code debugging while users are still down and rollback exists → mitigate
first.

## Process

Two phases: **during** (mitigate → communicate → diagnose) and **after** (learn → fix systems).

---

### Phase A — During the incident

Work in order. Stabilize before you theorize.

#### 1. Triage — assess impact in minutes

Answer quickly:

| Question | Why |
|----------|-----|
| **What** is broken? (service, region, feature) | Scope the blast radius |
| **Who** is affected? (all users, subset, internal only) | Severity |
| **How bad?** (down, degraded, data risk) | Mitigation urgency |
| **Since when?** (deploy time, alert time, customer report) | Correlate to change |
| **Is impact growing?** | Escalate faster |

Use dashboards, alerts, and traces ([[observability]]) — not only customer reports. Reports lag;
metrics lead.

**Severity guide** (adapt to your org):

| Level | Typical signal | Response |
|-------|----------------|----------|
| **Critical** | Core path down, data loss risk, security breach | All-hands, exec comms, immediate mitigate |
| **Major** | Large subset degraded, no workaround | Incident declared, coordinator, frequent updates |
| **Minor** | Limited feature, workaround exists | Fix in business hours; may not need full incident |
| **Near-miss** | Could have been major; caught early | Postmortem still valuable |

If unsure, declare early and downgrade later — ambiguous chaos costs more than a false alarm.

#### 2. Declare and coordinate — one brain for the response

- **Declare an incident** — name, severity, channel (`#incident-YYYY-MM-DD-foo`).
- **Assign roles** (can be one person on small teams):

| Role | Owns |
|------|------|
| **Incident Commander (IC)** | Decisions, priorities, "what we try next", all-clear |
| **Tech lead / investigator** | Hypothesis, logs, mitigations execution ([[fault-recovery]]) |
| **Comms** (IC or delegate) | Stakeholder updates, status page, support |

**One coordinator** makes the call when opinions split. Others propose; IC decides. Avoid five people
changing prod independently.

Start a **living timeline** — timestamped facts, not debate:

```text
14:02 — p95 checkout latency alert fires
14:05 — incident declared, IC: @name
14:08 — correlated with deploy v2.4.1
14:12 — rollback v2.4.1 started
```

#### 3. Mitigate first — fastest **safe** fix

You do **not** need root cause to stop bleeding. Pick the fastest mitigation with acceptable risk:

| Mitigation | When | Watch out |
|------------|------|-----------|
| **Rollback deploy** | Recent deploy correlates | Data migrations may not roll back cleanly ([[migration-path]]) |
| **Feature flag off** | Isolated feature | Know flag default and cache TTL |
| **Scale up** | Load/saturation | Doesn't fix bug; cost; may amplify bad writes |
| **Failover / drain node** | Bad instance, region issue | Data consistency |
| **Disable endpoint/job** | Non-critical path overloading shared deps | User-visible degradation — communicate |
| **Rate limit / shed load** | Overload, dependency slow | Legitimate traffic dropped |
| **Bypass cache** | Stale/wrong cache serving | Origin load spike |
| **Failover to degraded mode** | Dependency down ([[resilience]]) | Document what's degraded |

**Test rollback before you need it** ([[launch-readiness]]). Mid-incident is a bad time to discover
rollback doesn't revert a migration.

Prefer **revert** on shared branches over force-push ([[git-flow]]). Hotfixes branch from what's in
prod if `main` has diverged.

If first mitigation doesn't help within a reasonable window — try the next hypothesis, don't doggedly
debug one theory while users suffer.

#### 4. Communicate — steady cadence, no silence

Stakeholders panic when dark. **Comms** owns a rhythm:

- **Internal:** every 15–30 min during critical/major — impact, current action, ETA if known, next update time
- **External:** status page / support macros when user-visible — factual, no speculation
- **Engineering channel:** technical detail, hypotheses, commands run — IC curates what goes wide

**Update template:**

```text
Impact: [who/what broken]
Current status: [investigating / mitigating / monitoring]
Actions taken: [rollback, flag off, …]
Next: [what we're trying / waiting for]
Next update: [time]
```

Say when you **don't know** ETA — don't invent one. Correct earlier statements when facts change.

#### 5. Diagnose after stabilize — disciplined, one change at a time

Once user impact is **stopped or bounded**, find root cause ([[fault-recovery]]):

- Use logs, metrics, traces with correlation ids ([[observability]])
- Correlate deploys, config changes, dependency status, traffic shifts
- **One change at a time** even under pressure — parallel prod experiments compound outages
- Capture evidence for postmortem — graphs, trace ids, commit sha

IC decides when to shift from "mitigate mode" to "diagnose mode" — not every responder at once.

**Don't** add unreviewed hotfixes to prod while still unstable unless IC explicitly accepts risk.
Minimal revert > clever forward fix under fire.

#### 6. Confirm recovery — don't close early

Before **all-clear**:

- Error rate / latency back to normal baselines — not just "looks OK"
- Watch **15–60 min** for recurrence (cache refill, retry storms)
- Check **downstream** — queues drained, no poison messages, no partial data corruption
- Customer-facing paths smoke-tested ([[browser-checks]] if UI)

IC declares incident resolved; comms sends final update.

---

### Phase B — After the incident

Learning is part of the incident — not optional paperwork.

#### 7. Write a blameless postmortem

**Blameless** means: focus on **systems and conditions** that allowed failure, not punishing individuals.
People were doing their best with the tools and info they had.

**Post within a few days** — memory decays. Include:

```markdown
# Postmortem: [short title] — YYYY-MM-DD

## Summary
One paragraph: what broke, impact, duration, how resolved.

## Impact
- Users affected, duration, revenue/SLO/data risk (quantify where possible)
- Severity assigned

## Timeline (UTC)
| Time | Event |
|------|-------|
| … | Alert fired |
| … | Rollback completed |

## Root cause / contributing factors
What happened technically — and **contributing factors** (process, missing guardrail, alert gap).
Avoid single "root cause" mythology; incidents are usually multi-factor.

## What went well
Detection, rollback speed, comms — reinforce good habits.

## What went poorly
Gaps honestly — detection delay, rollback untested, unclear roles.

## Action items
| Item | Type | Owner | Due |
|------|------|-------|-----|
| Fix race in payment idempotency | fix | @eng | |
| Alert on queue depth > X | detect | @sre | |
| Runbook for dependency X outage | process | @sre | |
| Load test checkout before major releases | prevent | @eng | |
```

Share widely. Invite questions. **No blame** — ask "why was that mistake easy to make?"

Major architectural gaps → ADR or decision record ([[decision-docs]]).

#### 8. Action items — fix, detect, prevent, process

Every postmortem needs **owned, tracked** items — not a list that dies in a doc:

| Type | Example |
|------|---------|
| **Fix** | Patch bug, idempotency, migration repair |
| **Detect** | New alert, SLO, synthetic check |
| **Prevent** | Test, load test, feature flag default, circuit breaker |
| **Process** | Runbook, game day, on-call rotation, deploy gate |

**Track to done** in your issue tracker — same rigor as product work. Review in team meeting until
closed. Recurring incidents with open action items from the last one = process failure.

#### 9. Improve the system, not the person

Ask **five whys** on systems:

- Why did deploy break prod? → No canary. **Why no canary?** → Not in pipeline. **Fix pipeline.**
- Why did on-call miss it? → Alert on CPU not errors. **Fix alert.**

"Human error" stops at "human shouldn't have been the safety net."

---

### Establishing incident practices (for teams)

When not in active fire:

- **On-call rotation** with escalation path and runbooks ([[observability]])
- **Runbooks** for common failures — rollback steps, dependency contacts, data repair
- **Game days** — practice rollback and comms before real outage
- **Deploy safety** — flags, canaries, automated rollback ([[launch-readiness]], [[pipeline-ops]])
- **Incident review** — monthly scan of open postmortem actions

---

### Scenario playbooks

**Deploy regression (errors spike after release)**

Correlate timestamp → rollback or flag → confirm metrics → root cause in bad commit → regression test.

**Dependency outage (Stripe, AWS, SaaS API)**

Mitigate degrade mode ([[resilience]]) → comms on external dependency → status page → don't cascade
retries → postmortem on timeout/retry config.

**Database overload / lock storm**

Stop write traffic if needed → kill bad query/job → scale read path only if safe → root cause query or
migration ([[data-modeling]]).

**Traffic spike / DDoS**

Rate limit, WAF, scale → distinguish attack vs legitimate → comms if user-visible throttling.

**Data corruption or wrong data shown**

Assess scope → stop propagation (disable feature, block writes) → **don't** silent patch without
understanding blast radius → may need [[migration-path]] repair script.

**Security incident**

Mitigate exposure (revoke keys, block vector) → [[hardening]] → may involve legal/compliance;
parallel security track; careful comms.

**Flaky cascade (retries amplify outage)**

Reduce retries/concurrency → isolate dependency → fix circuit breaker / timeout ([[resilience]]).

**Near-miss (caught before users)**

Still write a lightweight postmortem — cheaper incidents teach the same system gaps.

## Common Rationalizations

- "Let me find root cause first." — Stop user impact first; root cause second.
- "We don't need a postmortem — we know what happened." — Undocumented lessons are relearned the hard way.
- "It was human error." — Ask why the system made that error easy or inevitable.
- "Just hotfix straight to prod." — Skipping checks mid-incident often deepens it; revert is often faster.
- "Rollback is too risky." — Compare rollback risk to ongoing outage risk; rehearse rollback before you need it.
- "Too small for an incident." — Declare and downgrade; chaos costs more than a false alarm.
- "Everyone's helping in prod." — Coordinate; parallel changes compound mystery.
- "Action items in the doc are enough." — Untracked items mean recurrence.
- "Customers haven't complained yet." — Metrics lead; silence isn't health.

## Red Flags

- Debugging root cause while users down and rollback available
- No incident commander; multiple people changing prod independently
- Stakeholders without updates for 30+ minutes during major incident
- Mitigation untried because "we need to understand it first"
- Hotfix without IC approval while incident still active
- All-clear before metrics normalized and soak period watched
- Postmortem assigns blame or single "root cause" without contributing factors
- Action items without owners or due dates
- Same failure mode twice with prior postmortem actions still open
- Rollback attempted but migration made it impossible — untested rollback plan
- Comms promised ETA repeatedly missed without correction
- Incident closed with no postmortem scheduled

## Verification

### During incident

- [ ] Impact triaged — what, who, how bad, since when, growing?
- [ ] Incident declared; IC assigned; roles clear; timeline started
- [ ] Fastest safe mitigation executed before deep diagnosis
- [ ] Stakeholders updated on cadence; external comms if user-visible
- [ ] Diagnosis disciplined after stabilize — one change at a time ([[fault-recovery]])
- [ ] Recovery confirmed on metrics + soak; downstream checks done
- [ ] IC declared all-clear; final comms sent

### After incident

- [ ] Blameless postmortem written within days — timeline, impact, contributing factors
- [ ] Action items categorized (fix/detect/prevent/process) with owners and dates
- [ ] Items tracked to completion — not abandoned in a doc
- [ ] Architectural or policy gaps recorded ([[decision-docs]]) if needed
- [ ] Runbooks/alerts/rollout improved so next response is faster ([[observability]], [[launch-readiness]])
