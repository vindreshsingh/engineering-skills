# Technical Writing Checklist

Quick reference alongside [[technical-writing]].

## Before writing

- [ ] Primary reader identified
- [ ] Doc type chosen (README, API, runbook, setup, changelog)
- [ ] Outline matches standard shape for that type

## Content

- [ ] First paragraph: what + who it's for
- [ ] Quick start works on clean machine (commands tested)
- [ ] Code blocks copy-pasteable; placeholders marked
- [ ] API: request + success + one error example per endpoint
- [ ] Runbook: symptom → diagnose → fix → escalate

## Quality

- [ ] Scannable headings and bullets
- [ ] No secrets in examples
- [ ] Links work; versions current
- [ ] "Last verified" date on setup guides
- [ ] Same PR as code change (or tracked follow-up)

## Runbook-specific

- [ ] Alert names / log queries included
- [ ] Rollback step documented
- [ ] On-call escalation path clear
