---
description: Run a design-time security risk pass using the threat-modeling skill.
---

Follow the `threat-modeling` skill (`skills/threat-modeling/SKILL.md`). Model the system and its trust
boundaries, enumerate threats systematically (STRIDE or equivalent) with special attention to untrusted
input and per-boundary authorization, rate each by likelihood × impact, and decide a recorded response
for every one (mitigate / eliminate / transfer / accept-with-owner). Consider abuse cases (IDOR,
uploads, automation, prompt injection), then hand mitigations to `test-first` and `hardening`.

$ARGUMENTS
