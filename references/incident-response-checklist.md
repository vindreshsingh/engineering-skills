# Incident Response Checklist

Quick reference alongside [[incident-response]].

## Triage (first 15 min)

- [ ] Incident declared; severity assigned
- [ ] Incident commander or owner named
- [ ] User impact assessed and communicated
- [ ] Mitigation started (rollback, scale, disable feature)

## Mitigate

- [ ] Stop the bleeding before root cause
- [ ] Status page or stakeholder update if external impact
- [ ] Timeline channel open (Slack war room, etc.)

## Resolve

- [ ] Fix verified in prod
- [ ] Monitoring confirms recovery
- [ ] All-clear communicated

## Post-incident

- [ ] Postmortem scheduled (blameless)
- [ ] Action items with owners and dates
- [ ] Runbook updated ([[technical-writing]])
