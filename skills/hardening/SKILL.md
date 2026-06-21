---
name: hardening
description: Applies security fundamentals — input validation, authorization, secret handling, and safe defaults. Use when handling untrusted input, auth, sensitive data, webhooks, LLM prompts, file uploads, or reviewing code for vulnerabilities.
---

# Hardening

Assume input is hostile and the network is not your friend. Most vulnerabilities come from trusting
something you shouldn't: user input, a token, a default config, an upstream response, or text stuffed
into an LLM prompt. **Validate at boundaries**, **authorize every action**, **protect secrets**, and
**fail closed** when something is wrong.

Security is not a final scan — it's built into every change that crosses a trust boundary. Retrofitting
after ship is slower and always misses something.

Run the [security checklist](../../references/security-checklist.md) alongside this process for a quick
pass. For supply-chain and dependency CVEs, pair with [[dependency-hygiene]]. For review workflow,
see [[review-gate]] and the security-auditor agent. For logging without leaking data, see
[[observability]].

## When to Use

- Any input crosses a trust boundary — HTTP params, JSON bodies, headers, cookies, uploads, webhooks
- Authentication, authorization, sessions, JWTs, or API keys
- Storing, transmitting, or logging sensitive or personal data (PII, payment, health)
- Building or reviewing APIs, forms, admin tools, or multi-tenant features
- LLM features with user or external content in prompts ([[llm-feature-engineering]])
- Configuring production — TLS, headers, CORS, rate limits, secrets
- Security-focused PR review or pre-launch pass ([[launch-readiness]])

Skip as the primary skill for pure internal refactors with no boundary change — still scan if the diff
touches auth, validation, or data access paths.

## Process

Work in order. Map boundaries before diving into individual lines.

### 1. Map trust boundaries

List where **untrusted data enters** and where **privileged actions** happen:

| Boundary | Untrusted inputs | Privileged actions |
|----------|------------------|-------------------|
| Public API | Query, body, headers | Read/write any user's data |
| Admin UI | Same + file uploads | Bulk export, role changes |
| Webhook handler | Raw body, signature header | Trigger internal jobs |
| Background job | Queue message, S3 key | DB writes, outbound calls |
| LLM pipeline | User text, retrieved docs | Tool calls, SQL generation |
| Browser | DOM, localStorage | Usually server must re-verify |

Every arrow from untrusted → trusted is where controls must live. **Client-side checks are UX, not
security** — repeat validation and authorization server-side.

### 2. Validate input at the boundary — allowlist

Validate **as soon as data enters** your code — type, range, format, size — before it reaches SQL,
shell, templates, or business logic.

**Allowlist** what's acceptable; don't blocklist "bad" strings (attackers invent new ones).

```text
Good: email must match RFC-ish pattern; age 0–120; enum status in {pending, paid}
Bad:  strip '<script>' and hope
```

**Size limits** on everything — body size, array length, string length, upload bytes. Unbounded input
is a DoS vector.

**Types** — parse JSON/schema strictly; reject unknown fields when the contract is fixed
([[interface-design]]).

**Files** — verify type and size; store outside web root; generate safe names — never use user path
as filesystem path (see uploads below).

Reject invalid input with a **generic client message**; log details server-side without secrets.

### 3. Never concatenate untrusted data into interpreters

Injection happens when untrusted data becomes **syntax** in SQL, shell, HTML, URLs, or templates.

| Risk | Unsafe | Safe |
|------|--------|------|
| SQL | `"SELECT ... WHERE id = " + id` | Parameterized queries / prepared statements |
| Shell | `os.system("convert " + path)` | Argument array APIs; no shell |
| HTML/XSS | Template with unescaped user HTML | Auto-escape templates; CSP |
| NoSQL | `{$where: userInput}` | Typed queries; operator allowlist |
| LDAP/XML | String concat | Library APIs with parameters |

**Output encoding** matters at the sink — HTML context ≠ JS context ≠ URL context. Encode for where
data lands.

For redirects and links: allowlist destinations or map IDs to URLs — don't `redirect(userSuppliedUrl)`
(open redirect).

### 4. Authorize every protected action — server-side

**Authentication** (who are you?) ≠ **authorization** (may you do *this* to *this* object?).

For every endpoint and mutation:

1. Is the caller authenticated (if required)?
2. Is the caller allowed to perform **this action**?
3. On **this specific resource** (row, file, tenant)?

**IDOR** (insecure direct object reference) — classic bug:

```text
GET /api/orders/123   — does 123 belong to this user/tenant?
DELETE /files/{id}    — verify ownership before delete
```

Check authorization **in the handler or service layer** — not only hiding buttons in the UI.

**Multi-tenant:** scope every query by `tenant_id` (or equivalent) from the authenticated session —
never from a client-supplied field without verification ([[data-modeling]]).

**Least privilege** — roles, service accounts, and DB credentials get minimum permissions needed.

### 5. Sessions, tokens, and API keys

- Use **standard flows** — OAuth2/OIDC, session cookies with `HttpOnly`, `Secure`, `SameSite`
- **Short-lived** access tokens; refresh rotation where appropriate
- **Invalidate** on logout, password change, and compromise
- **Don't store secrets** in localStorage if avoidable — XSS steals them
- API keys: scoped, rotatable, hashed at rest, never logged
- **Don't roll your own** session tokens or password hashing — use vetted libraries (bcrypt/argon2,
  framework session stores)

Verify **webhook signatures** (HMAC, timestamp) before trusting body — treat unsigned webhooks as
untrusted input.

### 6. Secrets and sensitive data

**Never in:**

- Source code, git history, screenshots
- Client bundles or mobile apps (assume extracted)
- Logs, metrics labels, error messages, support tickets auto-filled from stack traces
- URLs query params

**Do:**

- Load from secrets manager / env at runtime ([[git-flow]] — scan diffs)
- **Rotate** immediately if leaked — removal from git is not enough
- **Scrub** PII and secrets from logs and traces ([[observability]])
- Encrypt **in transit** (TLS everywhere) and **at rest** where required (DB, backups, disks)

Classify data — what's PII, payment, health — and model retention/delete paths ([[data-modeling]],
[[decision-docs]] for compliance rationale).

### 7. Fail closed with safe defaults

When auth, validation, or dependency checks fail — **deny**, don't degrade to open:

| Wrong | Right |
|-------|-------|
| `catch { return true }` | Reject request; log internally |
| Missing role → full access | Missing role → deny |
| Config default `auth=false` | Default deny; explicit opt-in to expose |
| Error returns stack trace to client | Generic message; details in server log |

**Production defaults:**

- TLS on; HSTS where appropriate
- Security headers — `Content-Security-Policy`, `X-Content-Type-Options`, `X-Frame-Options` or CSP
  `frame-ancestors`
- **Restrictive CORS** — explicit origins, not `*` with credentials
- Debug endpoints and admin panels disabled or gated in prod
- Rate limits and abuse protection on login, signup, expensive APIs, and LLM endpoints

### 8. High-risk patterns — check explicitly

**SSRF** — user-supplied URLs fetched server-side:

- Allowlist domains; block metadata IPs (`169.254.x`, internal ranges)
- Don't pass raw URL to HTTP client from user input

**File upload / path traversal**

- Never `open(userSuppliedPath)` — map to internal ID or sanitized name
- Store outside web root; serve via controlled handler with authz check

**Deserialization** — don't deserialize untrusted data into rich objects (Java, Python pickle, etc.)

**Mass assignment** — don't bind request JSON directly to DB models without field allowlist

**Caching** — personalized or auth responses not cached under global keys ([[caching-strategy]])

**LLM / AI** ([[llm-feature-engineering]])

- Untrusted text in prompts = **prompt injection** surface
- Never `eval` model output; validate structured output against schema
- Tool calls from model: allowlist tools and arguments; authz as if user called API
- Cap input size; log prompts without PII where possible

### 9. Dependencies and known vulnerabilities

A vulnerable library is your vulnerability ([[dependency-hygiene]]):

- Pin and audit in CI
- Patch critical/high on production deps promptly
- Vet new packages before adopt

Don't disable security features of frameworks to "make it work."

### 10. Verify — don't assume secure

Before merge or launch:

1. Run the [security checklist](../../references/security-checklist.md).
2. **Trace one untrusted input** through to storage/output — did validation and authz hold?
3. Try **horizontal access** — user A's token on user B's resource ID.
4. Trigger **error paths** — do responses leak internals?
5. Grep for secrets — `git log`, trufflehog, IDE patterns.
6. Confirm dependency audit clean or exceptions documented.

For significant surface changes, use security-auditor persona or peer review with attack scenarios.

### 11. Scenario playbooks

**New public API endpoint**

Boundary map → schema validation → authz on object → parameterized queries → rate limit → checklist.

**Login / signup**

Rate limit, credential stuffing protection, secure cookies, generic errors ("invalid credentials"),
no user enumeration via error messages.

**Admin or bulk export**

Strong authz role check, audit log who exported what, limit row count, no IDOR on export filters.

**Webhook receiver**

Verify signature + timestamp → parse JSON → treat as untrusted → idempotent handler ([[resilience]]).

**Multi-tenant feature**

Tenant from session only; every query scoped; test cross-tenant access explicitly.

**LLM feature with tools**

Allowlist tools; validate tool args; same authz as direct API; block instruction override in user text
where possible (delimiter patterns, separation — not foolproof, layer defenses).

**Security regression in PR**

Diff trust boundaries → focus review on changed edges → checklist → targeted tests for authz bypass.

## Common Rationalizations

- "Our users wouldn't do that." — Attackers aren't your users; bots scan everything.
- "It's behind auth." — Authenticated users still attack IDs they shouldn't reach; check authz.
- "We'll add validation later." — Exploitable the moment it ships.
- "It's an internal service." — Internal boundaries get crossed; defense in depth.
- "We validate on the client." — Client is attacker-controlled; server must enforce.
- "CORS is fine — we use JWT." — Misconfigured CORS still matters; defense in layers.
- "It's only a low-severity CVE." — Chain lows into highs; track and time-box fixes.
- "Security headers break our embed." — Fix embed properly; don't drop CSP globally.
- "The LLM won't follow malicious instructions." — Assume it will; constrain tools and output.

## Red Flags

- User input concatenated into SQL, shell, HTML, or template strings
- `GET` handler changes state without authz check
- Login checked but not permission on the specific resource (IDOR)
- `tenant_id` or `userId` taken from request body without verification
- Secrets in repo, config, client bundle, or logs
- Stack traces, internal paths, or tokens in API responses
- `catch (e) { }` or default-allow on auth failures
- `Access-Control-Allow-Origin: *` with credentials
- No rate limiting on auth or expensive endpoints
- User-controlled URL fetched server-side without SSRF controls
- File path built from user input
- `eval`, `pickle.loads`, or equivalent on untrusted data
- Model output executed or parsed without schema validation
- Outdated dependencies with known critical/high advisories
- Security checklist skipped for "small" API change

## Verification

- [ ] Trust boundaries mapped; server-side enforcement on every edge
- [ ] Input validated at boundary by allowlist — type, range, format, size
- [ ] No injection sinks — parameterized queries, safe encoders, no concat
- [ ] Authorization checked per action and per object; tenant scoped ([[data-modeling]])
- [ ] Sessions/tokens standard, expiring, invalidated on logout; webhooks verified
- [ ] No secrets in code, logs, or client; PII scrubbed from telemetry ([[observability]])
- [ ] Fail closed — deny default, safe errors, TLS, headers, restrictive CORS
- [ ] SSRF, upload, deserialization, mass-assignment risks addressed if applicable
- [ ] LLM paths: no blind trust of output; tools allowlisted; injection layered ([[llm-feature-engineering]])
- [ ] Dependencies audited; highs addressed ([[dependency-hygiene]])
- [ ] [Security checklist](../../references/security-checklist.md) completed for the change
