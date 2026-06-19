# Security Checklist

A quick checklist to run alongside the [[hardening]] skill. Default stance: input is hostile, fail
closed, grant the least privilege that works.

## Input

- [ ] Untrusted input validated at the boundary — type, range, size, format — by allowlist.
- [ ] No untrusted data concatenated into SQL/NoSQL, shell, templates, or HTML; use parameterized
      queries and safe encoders.
- [ ] File uploads checked for type/size; paths can't escape their directory (no traversal).
- [ ] Outbound URLs from user input can't reach internal services (SSRF).
- [ ] No deserialization of untrusted data into rich objects.

## Authentication & Authorization

- [ ] Every protected action checks authorization server-side, per request and per object.
- [ ] Authn is not treated as authz — being logged in ≠ allowed to do this.
- [ ] No insecure direct object references (IDOR) — ownership is verified.
- [ ] Sessions/tokens expire, rotate, and are invalidated on logout/password change.

## Secrets & Data

- [ ] No secrets in source, config, or logs; loaded from a secrets manager/env.
- [ ] Sensitive/PII fields scrubbed from logs and error responses.
- [ ] Data encrypted in transit (TLS) and, where required, at rest.
- [ ] Standard, vetted libraries for hashing/encryption/auth — never hand-rolled.

## Defaults & Exposure

- [ ] Deny by default; least privilege for every role and credential.
- [ ] Errors don't leak stack traces, internal paths, or tokens.
- [ ] Security headers and a restrictive CORS policy in place.
- [ ] Rate limiting / abuse protection on sensitive or expensive endpoints.

## Dependencies

- [ ] Dependencies pinned and free of known advisories (audit run).
- [ ] New dependencies vetted before adoption.
