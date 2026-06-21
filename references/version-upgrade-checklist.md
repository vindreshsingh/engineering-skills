# Version Upgrade Checklist

Run alongside [[version-upgrade]] when bumping a package from current → target version.

## Scope

- [ ] Package name and ecosystem recorded (npm, pip, cargo, go, etc.)
- [ ] **Current** version from lockfile (not just manifest range)
- [ ] **Target** version chosen with reason (feature, CVE, EOL, peer)
- [ ] One package or coupled peer group per PR — unrelated bumps split out

## Research (web + docs — before editing code)

- [ ] Web search: `{package} {current} to {target} migration`
- [ ] Web search: `{package} {target} release notes breaking changes`
- [ ] Official **migration / upgrade guide** read (if major jump)
- [ ] **CHANGELOG / GitHub Releases** read from `current+1` through `target`
- [ ] Official docs checked for deprecations, new defaults, engine requirements
- [ ] Peer dependencies and supported version matrix noted
- [ ] Findings captured: features | breaking changes | deprecations

## Codebase impact

- [ ] Imports / requires / config usage grepped across repo
- [ ] Config files listed (`*.config.*`, CI, Docker, `.nvmrc`, engines)
- [ ] Breaking-change → file → fix strategy table filled
- [ ] Peer packages that must bump together identified
- [ ] Lockfile transitive major bumps scanned in diff
- [ ] Wide blast radius? → [[migration-path]] plan if needed

## Execute

- [ ] Prerequisites upgraded (Node/Python/runtime, parent framework)
- [ ] Version bumped; lockfile committed ([[dependency-hygiene]])
- [ ] Official **codemod** run if documented
- [ ] Manual fixes applied per migration guide (not guessed)
- [ ] Config keys migrated; old keys removed from repo
- [ ] Peer dependency warnings resolved or documented exception
- [ ] No unexplained `@ts-ignore`, `--legacy-peer-deps`, or audit suppressions

## Verify

- [ ] Clean install in CI (`npm ci`, frozen lock, etc.)
- [ ] Build / typecheck passes
- [ ] Tests pass; critical paths smoke-tested ([[browser-checks]] for UI)
- [ ] No new critical/high vulnerabilities ([[dependency-hygiene]])
- [ ] Bundle/perf regression checked if front-end ([[perf-budget]])

## PR / docs

- [ ] PR lists: why, breaking changes fixed, new features used
- [ ] Links to migration guide and release notes
- [ ] Rollback approach noted
- [ ] Major framework jump → ADR if appropriate ([[decision-docs]])
