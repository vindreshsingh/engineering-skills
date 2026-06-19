---
name: hardening
description: Applies security fundamentals — input validation, authz, secret handling, safe defaults. Use when handling untrusted input, auth, sensitive data, or reviewing code for vulnerabilities.
---

# Hardening

Assume input is hostile and the network is not your friend. Most vulnerabilities come from trusting
something you shouldn't: user input, a token, a default, or an upstream response. Validate, authorize,
and fail closed.

## When to Use

- Handling any input that crosses a trust boundary (requests, params, uploads, webhooks)
- Authentication, authorization, sessions, or access control
- Storing or transmitting secrets or sensitive/personal data
- Reviewing a change for security exposure

## Process

1. **Validate and sanitize untrusted input** at the boundary — type, range, format, size. Allowlist
   what's acceptable rather than blocklisting what isn't.
2. **Use parameterized queries and safe encoders.** Never build SQL, shell, or HTML by string
   concatenation with user data; let the layer escape it.
3. **Check authorization on every protected action**, server-side, per request. Authentication is not
   authorization; verify the caller may do *this* to *this object*.
4. **Keep secrets out of code and logs.** Use a secrets manager/env, rotate, and never commit keys.
   Scrub sensitive fields from logs and errors.
5. **Fail closed with safe defaults.** Deny by default, minimum privilege, no secrets or stack traces
   in responses, security headers and TLS on.
6. **Mind dependencies and known CVEs.** Pin and update; a vulnerable library is your vulnerability.
7. **Don't roll your own crypto/auth.** Use vetted libraries and standard flows.

## Common Rationalizations

- "Our users wouldn't do that." — Attackers aren't your users, and inputs come from everywhere.
- "It's behind auth." — Authenticated users can still attack data they shouldn't reach; check authz.
- "We'll add validation later." — The gap is exploitable the moment it ships.
- "It's an internal service." — Internal boundaries get crossed; defense in depth assumes they will.

## Red Flags

- User input concatenated into a query, command, or markup
- Endpoints that check login but not permission on the specific resource
- Secrets in the repo, config, or log output
- Errors that leak stack traces, internal paths, or tokens
- Outdated dependencies with known advisories
- Hand-rolled hashing/encryption/token logic

## Verification

- [ ] Untrusted input validated/sanitized at the boundary (allowlist)
- [ ] Queries parameterized; output safely encoded
- [ ] Authorization checked server-side on every protected action
- [ ] No secrets in code, config, or logs; sensitive data scrubbed
- [ ] Safe defaults: deny-by-default, least privilege, no leaky errors
- [ ] Dependencies current; standard libraries used for crypto/auth
