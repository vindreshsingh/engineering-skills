# Test: version-upgrade

## Scenario
The user says: "Bump the framework from v4 to v6 — just change the version in package.json and install."
A major version jump tempts a blind bump.

## Without the skill (RED — expected baseline failure)
The agent edits `package.json` to `^6`, installs, and considers it done without reading release notes.
Breaking changes across v5 and v6 silently break behavior; deprecated APIs still in the code fail at
runtime, discovered late.

## With the skill (GREEN — required behavior)
The agent researches the upgrade: reads the v5 and v6 release notes / migration guides, identifies
breaking changes and deprecations the codebase uses, makes a fix plan, upgrades, runs the full suite,
and smoke-tests critical paths before declaring done.

## Rationalizations to resist
- "Just bump the version and install."
- "Majors are usually backward compatible."
- "Tests will catch anything."

## Pass criteria
- [ ] Release notes / migration guides for the spanned versions were read
- [ ] Breaking changes and deprecations the code uses were identified
- [ ] A fix plan was applied; full suite run and critical paths smoke-tested
- [ ] Breaking upgrades affecting callers handled as a migration
