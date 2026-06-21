# Agent Guardrails Checklist

Always-on checks for AI agents. Full process: `skills/agent-guardrails/SKILL.md`.

## Before destructive or sensitive actions

- [ ] Classified action: safe / sensitive / blocked-without-consent
- [ ] Environment confirmed (local / staging / prod / unknown → treat as prod)
- [ ] Blast radius named (table, path, bucket, namespace)
- [ ] Rollback or backup path identified for sensitive mutations

## Blocked without explicit user consent

- [ ] No `DROP`, `TRUNCATE`, or unscoped `DELETE` / mass `UPDATE`
- [ ] No `rm -rf` on unverified or production paths
- [ ] No cloud/infra resource deletion without scoped plan review
- [ ] No `git push --force` to main/master without warning + consent
- [ ] No `git reset --hard` / `git clean -fdx` that discards others' work without consent

## Secrets — never read, search for, or leak

- [ ] Did not open `.env`, `.env.*` (except `.env.example`), credentials, keys, or token stores
- [ ] Did not grep/search repo for API keys, passwords, or tokens
- [ ] No secret values in chat, commits, logs, or examples (use placeholders)
- [ ] Did not pipe secrets from files into shell commands
- [ ] Warned if secret files appear staged for commit

## Security — fail closed

- [ ] Did not disable hooks, sandbox, auth, TLS, or scanners without explicit user request
- [ ] Did not modify git config or access unrelated systems
- [ ] Parameterized queries / allowlists — no concatenating untrusted input ([[hardening]])

## After the task

- [ ] No blocked action ran without documented approval naming the exact target
- [ ] Output contains no credentials, connection strings, or unnecessary PII
