# Launch Readiness Checklist

Quick reference alongside [[launch-readiness]].

## Pre-deploy

- [ ] CI green on release commit
- [ ] Staging verified at same artifact/commit as prod
- [ ] Feature flags and env config set in target environment
- [ ] Migrations applied or deploy order documented

## Rollback

- [ ] Rollback steps tested or rehearsed
- [ ] Rollback trigger defined (error rate, latency, manual)
- [ ] On-call or owner identified for launch window

## Observability

- [ ] Metrics/logs for new behavior
- [ ] Alerts configured for critical paths
- [ ] Dashboard link shared with team

## Communication

- [ ] Release notes / changelog drafted
- [ ] Stakeholders notified if user-visible
- [ ] Support/runbook updated if needed

## Rollout

- [ ] Gradual rollout plan (canary/%) if high risk
- [ ] Soak period defined before 100%
