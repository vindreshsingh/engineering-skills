---
name: dependency-hygiene
description: Manages third-party dependencies safely — vetting, pinning, updating, and supply-chain risk. Use when adding a library, upgrading or removing one, reacting to a security advisory, auditing what a project pulls in, or reviewing a PR that changes the dependency tree.
---

# Dependency Hygiene

Every dependency is code you didn't write running with your privileges — plus every transitive package
it pulls in. It's leverage and liability at once: you ship faster, but you inherit bugs, breaking
changes, license obligations, and supply-chain attack surface.

Treat dependencies like hiring: justify the need, vet before adopting, pin for reproducibility, review
on a cadence, and remove what you no longer use. Panic upgrades under a CVE deadline are expensive;
small regular updates are cheap.

Pairs with [[hardening]] for vulnerability response, [[pipeline-ops]] for CI gates and reproducible
builds, [[version-upgrade]] for researched version bumps, [[migration-path]] for breaking upgrades that
affect callers, [[review-gate]] when reviewing dependency PRs,
[[simplify]] when deciding to own code instead of import it, and [[decision-docs]] when a dependency
choice is hard to reverse (core framework, datastore driver, auth library).

## When to Use

- Adding a new runtime, dev, or build-time dependency
- Upgrading, downgrading, or removing a package
- Reacting to a security advisory (CVE, `npm audit`, OSV, GitHub Dependabot alert)
- Reviewing a PR that changes `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, etc.
- Auditing what the project depends on and whether each dep is still justified
- Onboarding to a repo with a bloated or ancient lockfile
- Choosing between two libraries for a core capability

Skip for vendored code you fully control with no package manager entry, or trivial config-only changes
with no dependency tree impact. Still apply when the "config" pulls a new tool into CI.

## Process

Work in order. Don't add to the lockfile until justification and vetting pass.

### 1. Justify before you install

Ask **"do we need a package for this?"** first ([[simplify]]).

| Prefer owning | Prefer a dependency |
|---------------|-------------------|
| A few lines of stable logic | Complex, security-sensitive domain (crypto, auth) |
| Standard library covers it | Well-maintained standard for the ecosystem |
| One-off transform with no edge cases | Active maintenance burden you'd carry forever |
| Already have a dep that does it | Dep is the de facto standard (test runner, linter) |

A one-function package (`is-odd`, `left-pad`) is rarely worth a new supply-chain edge. A wrong choice
in auth, ORM, or HTTP client is costly to unwind — justify and record ([[decision-docs]]).

**Removing** is hygiene too. Dead dependencies still get audited, scanned, and confused about in
reviews. Delete unused deps in the same PR that stops using them.

### 2. Vet before adopting

Run this checklist before the first `install`. For upgrades, re-check if the package changed
maintainers, license, or major behavior.

**Maintenance & trust**

- Recent releases or commits — abandoned packages don't get CVE fixes
- Responsive maintainers — critical issues open for months is a signal
- Download/adoption in your ecosystem — obscure isn't always bad, but know why you're early
- Single-maintainer risk — have a fallback plan
- Sudden maintainer transfer, repo URL change, or publish from a new account — **stop and investigate**

**License**

- Compatible with your product and distribution model (MIT/Apache vs GPL copyleft)
- Transitive licenses checked for surprises in enterprise/legal review
- No license = do not ship

**Footprint**

- How many **transitive** packages does it add? (`npm ls`, `pip show`, `go mod graph`)
- Bundle size impact for front-end (`bundlephobia`, build diff)
- Native bindings, postinstall scripts, or binary downloads — higher risk and CI complexity

**Security history**

- Known advisories on current version ([[hardening]])
- Past supply-chain incidents on this package or typosquat clones
- Does it run network code at install time?

**Fit**

- API matches your need without dragging a framework
- Works with your runtime version, platform, and deployment model
- Documented upgrade path — not stuck on a fork

Reject or escalate: unmaintained, license unclear, huge transitive tree for a trivial helper, suspicious
publish history, or duplicate of an existing dep.

### 3. Pin for reproducible builds

The lockfile is the contract. Everyone — dev, CI, production build — must resolve the **same tree**.

- **Commit the lockfile** (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`,
  `Cargo.lock`, `go.sum`, etc.)
- CI installs with **frozen lock** (`npm ci`, `pip install -r requirements.txt` from lock, etc.)
- Avoid wide ranges in direct deps (`^` / `>=`) without a lockfile — builds drift silently
- Pin **tool versions** in CI too ([[pipeline-ops]]) — same commit, same result

Document the install command in README or CI config. "Works on my machine" often means different lock
states.

For applications: lock everything. For libraries published to others: follow ecosystem conventions
(often wider ranges in `package.json` but lock in dev/CI).

### 4. Keep the surface minimal

Fewer, well-chosen dependencies beat a pile of overlapping ones.

- **One library per job** — don't add `lodash` and `underscore`
- **Prefer tree-shakeable imports** — `import { x } from 'lib/x'` not whole-barrel when it matters
- **Avoid deps of deps you could use directly** — don't import a wrapper that re-exports a peer
- **Platform builtins first** — `fetch`, `crypto`, standard library before polyfill packages
- **Internal shared packages** for org-wide code — not copy-paste, not random npm wrappers

When two deps conflict (duplicate transitive versions), resolve explicitly — overrides/resolutions are
a conscious choice with a reason, not a silent `npm install --force`.

### 5. Update on a cadence — not only in panic

**Regular small upgrades** beat annual "dependency week" or emergency CVE fire drills.

- Enable automated update PRs (Dependabot, Renovate) with CI running on each
- **Read changelogs** for direct deps — especially minors that change behavior
- Upgrade **one logical group at a time** (framework, test stack) when possible — easier bisect
- Breaking majors are **migrations** — follow [[version-upgrade]] for research and fixes, then
  [[migration-path]] if callers or contracts break

Cadence suggestion:

| Tier | Examples | Cadence |
|------|----------|---------|
| Security patch | CVE fixes | As soon as vetted + CI green |
| Patch/minor | bug fixes, safe minors | Weekly–monthly automated PRs |
| Major | framework majors | Planned sprint with migration plan |
| Dev-only | linters, test tools | Keep reasonably current; less urgent |

After upgrade: run full test suite, smoke critical paths, watch production after deploy
([[launch-readiness]]).

### 6. Audit continuously in CI

Security scan is a **merge gate**, not a quarterly spreadsheet ([[pipeline-ops]]).

- Run ecosystem audit in CI: `npm audit`, `pnpm audit`, `pip-audit`, `cargo audit`, `govulncheck`, OSV
- **Fail or warn on policy** — e.g. block merge on critical/high in production deps
- Track **devDependency** advisories too — they run in CI with repo access
- Don't ignore forever — suppress with ticket, expiry, and documented reason

Scan results are starting points. Verify:

- Is the vulnerable code path actually **reachable** in your app?
- Is there a fixed version? Does the fix require a major?
- Is the advisory disputed or false positive? Document the exception.

### 7. Guard the supply chain

Dependencies are a top attack vector — typosquats, compromised publishes, malicious postinstall scripts.

**Before merge / on alert:**

- Package name exact match — typosquat (`react-dom` vs `react_dom`) is common
- Publisher identity stable — investigate sudden ownership transfers
- **Postinstall / preinstall scripts** — know what runs; prefer packages without install scripts when possible; `ignore-scripts` in CI where safe
- Install from **official registries** — not random Git URLs without pinning to commit SHA
- **Lockfile integrity** — hash verification (`npm`, `pnpm`, `cargo`) enabled; review lockfile diffs in PRs
- **Provenance / sigstore** where ecosystem supports it — prefer signed publishes when available

In PR review ([[review-gate]]), a lockfile-only change with thousands of lines needs scrutiny — not
rubber-stamp. Unexpected new packages or version jumps on trusted names warrant a web search.

**Runtime:** dependencies don't get secrets from your env unless you give them. Minimize env exposure
in CI scripts that install packages.

### 8. Review dependency PRs deliberately

A dependency PR is not "just a version bump."

Check:

- [ ] Why — new capability, CVE, or drive-by bump?
- [ ] Changelog / release notes for breaking or behavior changes
- [ ] Lockfile diff — unexpected new packages or removed integrity entries
- [ ] License change in new version
- [ ] Bundle size or native binary changes (front-end, Docker image size)
- [ ] Transitive major bumps hidden inside the lockfile
- [ ] Tests and CI green on the PR branch — not assumed

Approve when justified, vetted, and verified — not when "it's just a dep."

### 9. Scenario playbooks

**Add a new dependency**

1. Justify vs own ([[simplify]]).
2. Vet checklist (maintenance, license, footprint, advisories).
3. Add with lockfile; smallest import surface.
4. Record in PR why it was chosen over alternatives if non-obvious.
5. CI audit passes.

**CVE / advisory response**

1. Confirm severity and **exploitability** in your code path.
2. Find fixed version; check for breaking change.
3. Patch upgrade ASAP if direct; if transitive, upgrade parent or documented override.
4. If no fix: mitigate (disable feature, WAF rule, input block) + track advisory.
5. Deploy and verify ([[launch-readiness]]).

**Major version upgrade**

1. Follow [[version-upgrade]] — web search, release notes, breaking-change table, fixes.
2. If internal/external callers break, extend with [[migration-path]].
3. Branch; upgrade; fix compile and tests in slices.
4. Staged rollout if behavior change is wide.
5. ADR or PR notes if the upgrade changes architecture ([[decision-docs]]).

**Audit existing tree**

1. List direct deps — mark each used / unused / replaceable.
2. Remove unused; consolidate duplicates.
3. Run audit; triage by severity and reachability.
4. Schedule majors and abandoned packages.
5. Document policy: cadence, allowed licenses, scan gate.

**Monorepo / polyglot**

- One lockfile policy per package root — don't mix install styles
- Shared tooling versions aligned where possible
- Understand which apps ship which transitive deps to production

## Common Rationalizations

- "Just npm install it." — Each install adds transitive code and risk; vet first.
- "Pinning is annoying." — Unpinned deps make builds non-reproducible and break silently on upstream changes.
- "We'll update later." — "Later" becomes an emergency when a CVE lands; small regular updates are cheaper.
- "It's a tiny package." — Tiny packages have been hijacked; size isn't safety.
- "Audit says low — ignore it." — Verify reachability; lows add up; policy should be explicit.
- "Lockfile diff is too big to review." — That's exactly when supply-chain attacks hide; skim new package names.
- "We need the latest for security." — Latest can introduce breaking bugs; pinned patched version beats bleeding edge.
- "DevDependencies don't matter." — They run in CI with credentials and clone access.
- "Everyone uses this package." — Popular packages are bigger targets; still vet and pin.

## Red Flags

- Heavy dependency added for a one-line helper
- No lockfile committed, or lockfile not used in CI install
- Wide version ranges with no lock in an application build
- Dependencies years out of date with open critical/high advisories
- New dependency unmaintained, license incompatible, or unknown footprint
- Postinstall scripts not reviewed; install from unpinned Git URL
- Lockfile PR with unexpected new packages or trusted-name version spikes
- Duplicate overlapping libraries doing the same job
- Security audit not run in CI, or ignored with no documented exceptions
- CVE "fixed" by override without upgrade or mitigation proof
- Transitive vulnerability ignored because "it's not our direct dep"
- Core framework choice with no recorded rationale ([[decision-docs]])

## Verification

- [ ] Each new dependency justified vs owning the code ([[simplify]])
- [ ] Vetted: maintenance, license, transitive footprint, advisories, typosquat check
- [ ] Lockfile committed; CI uses frozen install; tool versions pinned ([[pipeline-ops]])
- [ ] Surface minimal — no duplicate libs; unused deps removed
- [ ] Updates on cadence; changelogs read; majors treated as migrations ([[migration-path]])
- [ ] Security audit runs in CI; highs/criticals addressed or documented exception with expiry
- [ ] Supply-chain checks — postinstall scripts, lockfile diff reviewed, official sources
- [ ] Dependency PRs reviewed for hidden transitive and license changes ([[review-gate]])
- [ ] CVE response verified for reachability, fix version, deploy, and monitoring
- [ ] Significant dependency choices recorded when hard to reverse ([[decision-docs]])
