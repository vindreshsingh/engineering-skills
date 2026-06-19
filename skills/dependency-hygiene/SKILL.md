---
name: dependency-hygiene
description: Manages third-party dependencies safely — vetting, pinning, updating, supply-chain risk. Use when adding a dependency, upgrading one, or reviewing what a project pulls in.
---

# Dependency Hygiene

Every dependency is code you didn't write running with your privileges, plus its own transitive
dependencies. It's leverage and liability at once. Add deliberately, pin for reproducibility, update
on a cadence, and treat the supply chain as an attack surface.

## When to Use

- Adding a new library or tool to a project
- Upgrading dependencies, or reacting to a security advisory
- Reviewing a PR that introduces or bumps dependencies
- Auditing what a project depends on and why

## Process

1. **Justify the addition.** Does this need a dependency, or is it a few lines you can own? Weigh the
   maintenance and risk against the value — a one-function package isn't worth a new supply-chain edge.
2. **Vet before adopting.** Check maintenance (recent commits, open critical issues), popularity,
   license compatibility, transitive footprint, and known advisories. Avoid abandoned or single-commit
   packages.
3. **Pin for reproducible builds.** Commit the lockfile; use exact/locked versions so the same install
   yields the same tree everywhere ([[pipeline-ops]]).
4. **Prefer the smallest surface.** Fewer, well-maintained dependencies beat many overlapping ones;
   avoid pulling a large library for a trivial helper.
5. **Update on a cadence, not in panic.** Regular small upgrades (automated PRs) are safer than a giant
   jump under a CVE deadline. Read changelogs; breaking changes are migrations ([[migration-path]]).
6. **Audit continuously.** Run the ecosystem's audit in CI and act on high-severity advisories; don't
   let known-vulnerable versions linger ([[hardening]]).
7. **Guard against supply-chain attacks.** Watch for typosquats, sudden maintainer changes, and
   suspicious postinstall scripts. Verify integrity (lockfile hashes); prefer official sources.

## Common Rationalizations

- "Just npm install it." — Each install adds transitive code and risk; vet first.
- "Pinning is annoying." — Unpinned deps make builds non-reproducible and break silently on upstream changes.
- "We'll update later." — "Later" becomes an emergency when a CVE lands; small regular updates are cheaper.
- "It's a tiny package." — Tiny packages have been hijacked and broken the world; size isn't safety.

## Red Flags

- A heavy dependency added for a one-line helper
- No lockfile committed, or unpinned version ranges in production
- Dependencies years out of date with open advisories
- A new dependency that's unmaintained, obscure, or has a risky license
- Postinstall scripts or transitive packages no one reviewed
- Security audit not run in CI

## Verification

- [ ] Each dependency is justified vs. owning the code
- [ ] New deps vetted for maintenance, license, footprint, and advisories
- [ ] Lockfile committed; versions pinned for reproducible builds
- [ ] Dependency surface kept minimal
- [ ] Updates happen on a regular cadence with changelogs read
- [ ] Security audit runs in CI and high-severity issues are addressed
