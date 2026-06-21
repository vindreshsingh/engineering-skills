# Pipeline Ops Checklist

Quick reference alongside [[pipeline-ops]].

## CI pipeline

- [ ] Build, lint, test stages defined
- [ ] Required checks documented (required vs advisory)
- [ ] Secrets via CI secret store — not in repo
- [ ] Cache configured for faster builds

## Quality gates

- [ ] Unit tests run on PR
- [ ] E2E smoke on PR or nightly ([[e2e-testing]])
- [ ] Security scan (deps, SAST) if applicable

## Deploy

- [ ] Deploy to staging automated
- [ ] Prod deploy manual approval or gated
- [ ] Rollback job or documented revert path

## Reliability

- [ ] Flaky tests tracked and quarantined
- [ ] Pipeline failures notify owner channel
- [ ] Mean time to green monitored
