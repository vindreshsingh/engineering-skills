---
name: threat-modeling
description: Finds security risks at design time — before code exists — by mapping the system, enumerating how it could be attacked, and deciding what to do about each threat. Use when designing a feature that touches auth, data, money, or external input, when changing a trust boundary, or when a security-sensitive change needs a structured risk pass rather than a code-level review.
---

# Threat Modeling

Most security work happens too late — at code review ([[hardening]]) or in production
([[incident-response]]), after the expensive decisions are already baked in. Threat modeling moves the
security thinking to **design time**: look at what you're about to build, ask *how would someone attack
this?*, and decide — mitigate, accept, or redesign — before a line is written. It answers four
questions: **what are we building, what can go wrong, what are we going to do about it, and did we do a
good job?**

This is design-phase security, distinct from [[hardening]] (finding issues in a written diff) and
[[agent-guardrails]] (runtime blocking of dangerous actions). It feeds those: the model says *where* to
harden and *what* the guardrails must protect.

## When to Use

- Designing a feature touching **authentication, authorization, payments, PII, or secrets**
- Adding or changing a **trust boundary** — a new external input, integration, upload, or service call
- A [[spec-first]] / [[interface-design]] pass on anything security-sensitive, before implementation
- Before a risky [[migration-path]] that moves or exposes data differently
- A security-sensitive change needs a **structured risk pass**, not just a code skim

**Skip** when the change has no security-relevant surface (internal refactor, copy change, styling) —
don't ceremony-model a CSS tweak. For an already-written diff, use [[hardening]]; for a live attack or
breach, use [[incident-response]].

**Not a substitute for** [[hardening]] (code-level verification) — threat modeling decides *what
matters*; hardening confirms the code got it right.

## Process

### 1. Model what you're building — draw the data flow
Sketch the system: components, data stores, external entities, and the **trust boundaries** they cross
(user→app, app→DB, app→third-party, internet→service). You can't reason about attacks you can't see;
a simple data-flow diagram beats prose. Mark where data is **most sensitive** and where input is
**least trusted**.

### 2. Enumerate threats — be systematic, not lucky
Walk each element and boundary with a checklist so you don't just list the threats you happened to think
of. **STRIDE** is the common lens:

| Category | The threat | Ask |
|----------|-----------|-----|
| **S**poofing | Pretending to be someone else | Can identity be faked? Is auth enforced here? |
| **T**ampering | Unauthorized modification | Can data/requests be altered in transit or at rest? |
| **R**epudiation | Denying an action | Is there an audit trail for sensitive actions? |
| **I**nfo disclosure | Leaking data | Can someone read data they shouldn't? Over-broad responses, logs, errors? |
| **D**enial of service | Making it unavailable | Can input exhaust resources? Rate limits? |
| **E**levation of privilege | Gaining more access | Can a normal user reach admin actions? IDOR? |

Pay special attention to **untrusted input** (every external field, file, header, webhook) and
**authorization** at each boundary (authentication ≠ authorization — check both).

### 3. Rate each threat by risk
Score roughly by **likelihood × impact**. A trivially-exploitable PII leak outranks a theoretical DoS
needing insider access. You're prioritizing, not writing a thesis — high / medium / low is enough to
sequence the response.

### 4. Decide a response for every threat — the four options
For each threat, pick one and **write it down**:

- **Mitigate** — add a control (authz check, validation, rate limit, encryption, signed token)
- **Eliminate** — redesign so the threat can't exist (don't store the secret; don't accept the input)
- **Transfer** — push it to a system built for it (managed auth, a payment processor, a WAF)
- **Accept** — consciously, with a recorded reason and an owner (only for low risk)

"Mitigate" turns into concrete work items for the build; "accept" is a decision, not an oversight —
record it ([[decision-docs]]).

### 5. Don't forget abuse, not just bugs
Model **misuse**: a logged-in user attacking *other* users' data (IDOR), automation abusing a free tier,
a malicious file upload, prompt injection into an LLM feature ([[llm-feature-engineering]]). Many real
breaches are authorized users doing unauthorized things, not classic exploits.

### 6. Feed the result into build and verification
Each mitigation becomes a task and an acceptance criterion. Hand the list to [[hardening]] as the
review checklist for the diff, and to [[test-first]] so high-risk threats get a test that proves the
control works. Note runtime invariants for [[agent-guardrails]] / [[observability]] (alerting on the
attack signature).

### 7. Validate the model — did we do a good job?
Re-check: every trust boundary enumerated, every untrusted input has a validation decision, every
sensitive action has authz and an audit trail, and every threat has a recorded response. A model with
"no threats found" on an auth/payments feature is a model that wasn't done.

## Common Rationalizations

- "We'll catch it in code review." — Review finds bugs in *what you built*; threat modeling changes *what you build*. Some fixes are impossible to bolt on later.
- "It's internal, no one will attack it." — Internal users, compromised creds, and SSRF make "internal" a weak boundary; model it.
- "Authentication covers it." — Authentication is *who you are*; authorization is *what you may do*. IDOR lives in that gap.
- "STRIDE is overkill here." — Then it's a five-minute pass; the checklist exists so you don't miss the category you didn't think of.
- "No threats found." — On an auth/data/money surface that almost always means the model was too shallow, not that it's safe.
- "We'll just accept the risk." — Acceptance is valid only when written down with a reason and an owner; silent acceptance is negligence.

## Red Flags

- No data-flow / trust-boundary picture — modeling from memory
- Threats listed ad hoc instead of walked through a checklist (STRIDE or equivalent)
- Untrusted input with no explicit validation decision
- Authentication present but per-resource authorization unchecked (IDOR risk)
- Sensitive actions with no audit trail
- Threats enumerated but several left with no recorded response
- "Accepted" risks with no reason, owner, or revisit date

## Verification

- [ ] System modeled with components, data stores, external entities, and trust boundaries
- [ ] Threats enumerated systematically (STRIDE or equivalent), not ad hoc
- [ ] Untrusted inputs and per-boundary authorization explicitly examined
- [ ] Each threat rated by likelihood × impact and prioritized
- [ ] Every threat has a recorded response (mitigate / eliminate / transfer / accept-with-owner)
- [ ] Abuse/misuse cases (IDOR, upload, automation, prompt injection) considered, not just bugs
- [ ] Mitigations handed to [[test-first]] (high-risk tests) and [[hardening]] (review checklist); accepted risks in [[decision-docs]]
