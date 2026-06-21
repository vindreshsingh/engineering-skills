# Git Flow Checklist

Quick reference alongside [[git-flow]].

## Branch

- [ ] Branch name describes work (`feature/`, `fix/`, `chore/`)
- [ ] Up to date with base branch before PR

## Commits

- [ ] Focused commits — one logical change each
- [ ] Message explains why, not just what
- [ ] No secrets, `.env`, or credentials in diff

## Pull request

- [ ] Description: problem, approach, test evidence
- [ ] Linked ticket/spec if applicable
- [ ] Screenshots for UI changes
- [ ] Breaking changes called out

## Merge

- [ ] Review approved ([[review-gate]])
- [ ] CI green
- [ ] Squash or merge strategy matches team convention
