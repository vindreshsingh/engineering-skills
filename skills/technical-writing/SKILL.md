---
name: technical-writing
description: Writes clear technical documentation — README, API docs, runbooks, setup guides, and changelogs. Use when docs are missing, stale, or confusing, or when shipping a feature others must integrate with or operate.
---

# Technical Writing

Code without docs becomes tribal knowledge. Good technical writing answers **what it is**, **how to
use it**, and **what to do when it breaks** — for the reader who has never seen the codebase.

Pairs with [[decision-docs]] for ADRs, [[interface-design]] for API contracts, [[launch-readiness]]
for release notes, [[observability]] for runbook alerts, and [[migration-path]] for upgrade guides.

Use the [technical writing checklist](../../references/technical-writing-checklist.md) alongside this
process.

## When to Use

- New service, API, or library needs a README
- Setup/onboarding docs missing or outdated
- Runbook needed for on-call or operations
- Public or internal API needs reference docs
- Feature ships and integrators need how-to
- Changelog or release notes for a version

Skip for trivial one-line internal helpers with no external callers.

## Process

### 1. Identify reader and doc type

| Reader | Doc type | Goal |
|--------|----------|------|
| New developer | README, setup guide | Run locally in 15 min |
| API consumer | API reference, examples | Integrate without asking |
| Operator / on-call | Runbook | Fix incident in minutes |
| Maintainer | ADR, architecture overview | Understand why |
| End user | User guide (if product-facing) | Complete task |

Pick **one primary reader** per doc — don't mix operator and tutorial in one page.

### 2. Outline before writing

Standard shapes:

**README:** What → Quick start → Configuration → Development → License

**API doc:** Overview → Auth → Endpoints (method, path, request, response, errors) → Examples

**Runbook:** Symptom → Impact → Diagnosis steps → Fix → Escalation → Prevention

**Setup guide:** Prerequisites → Install → Verify → Troubleshooting

### 3. Write for scanability

- First paragraph = what + who it's for
- H2/H3 structure; bullets over walls of text
- Code blocks copy-pasteable — test every command
- `{placeholder}` for values users must replace
- Diagram or ASCII for flows >3 steps
- "Last verified" date on setup guides

### 4. Examples beat prose

Every API endpoint needs:

- Minimal request example
- Success response example
- One common error (401, 404, 422)

Every CLI needs `--help` output or equivalent in docs.

### 5. Keep docs close to code

- README in module root for that module
- Link ADRs from README ([[decision-docs]])
- Update docs in **same PR** as behavior change
- Deprecation notice before removal ([[migration-path]])

### 6. Review checklist

- [ ] New reader can follow quick start without asking
- [ ] Every command tested on clean environment
- [ ] No dead links; version numbers current
- [ ] Secrets shown as placeholders only
- [ ] Troubleshooting covers top 3 failure modes

## Common Rationalizations

- **"The code is self-documenting"** — Intent and ops context aren't in code.
- **"Docs can be a follow-up PR"** — Follow-up PRs rarely land; ship together.
- **"Auto-generated OpenAPI is enough"** — Examples and auth flow still need prose.
- **"Runbooks after first incident"** — Write the runbook before the incident.

## Red Flags

- Quick start fails on step 2
- API docs list fields with no example payload
- Runbook says "ask Alice" with no fallback
- README still describes removed features
- Credentials in copy-paste blocks

## Verification

- [ ] Reader and doc type identified
- [ ] Outline matches standard shape for that type
- [ ] Quick start / examples tested on clean environment
- [ ] Docs updated in same change set as code (or explicit follow-up ticket)
- [ ] Technical writing checklist passed
