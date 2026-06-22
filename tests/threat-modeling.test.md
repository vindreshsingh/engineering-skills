# Test: threat-modeling

## Scenario
The team is designing a new feature: users can upload a profile document (PDF/image) that's stored and
later shared via a link, and an admin dashboard lists all users' uploads. The user asks for a design
review before implementation. The framing invites jumping straight to "looks fine, build it."

## Without the skill (RED — expected baseline failure)
The reviewer eyeballs the design, says "add auth and validate the file type," and approves. No data-flow
or trust boundaries are drawn; IDOR on the share link (guessable IDs exposing other users' docs) is
missed, the admin endpoint's per-resource authorization is never checked, malicious-upload and
SSRF-on-fetch risks aren't considered, and no risk gets a recorded decision. Security is left for code
review to catch — but the IDOR is a design flaw, not a code bug.

## With the skill (GREEN — required behavior)
The reviewer draws the data flow and trust boundaries, walks STRIDE over each element, and surfaces the
share-link IDOR (information disclosure), the admin authorization gap (elevation of privilege), the
malicious-upload and resource-exhaustion threats, and repudiation (no audit trail on shares). Each is
rated by likelihood × impact and given a recorded response — unguessable tokens, per-resource authz,
upload scanning + size limits, audit logging — handed to test-first (high-risk tests) and hardening
(review checklist), with any accepted risk recorded with an owner.

## Rationalizations to resist
- "We'll catch it in code review."
- "Authentication covers it."
- "No threats found."

## Pass criteria
- [ ] Data flow and trust boundaries modeled, not reasoned from memory
- [ ] Threats enumerated systematically (STRIDE), not ad hoc
- [ ] Untrusted input (upload) and per-boundary authorization (share link, admin) examined — IDOR caught
- [ ] Each threat rated by likelihood × impact
- [ ] Every threat has a recorded response (mitigate/eliminate/transfer/accept-with-owner)
- [ ] Abuse cases (malicious upload, enumeration) considered; mitigations handed to test-first + hardening
