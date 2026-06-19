---
name: launch-readiness
description: Verifies a change is truly ready to ship — rollout, monitoring, rollback, and docs. Use before deploying or releasing anything to users, especially risky or user-visible changes.
---

# Launch Readiness

"Done coding" is not "ready to ship." Before a change reaches users, confirm you can release it safely,
watch it in production, and pull it back fast if it goes wrong. The riskier the change, the more this
matters.

## When to Use

- Before deploying a feature, migration, or significant change to production
- Cutting a release or rolling out to a wider audience
- Anything user-visible, hard to reverse, or touching critical paths
- Setting up a launch checklist for a team

## Process

1. **Confirm it works where it'll run.** Tests green, verified in a production-like environment, config
   and secrets in place for the target ([[browser-checks]] for UI).
2. **Plan the rollout.** Prefer gradual exposure — feature flag, canary, or staged percentage — over
   flipping it on for everyone at once. Decide the steps and who's watching.
3. **Have a rollback ready and tested.** Know the exact command/flag to undo it, and make sure it
   actually reverts cleanly (including any data effects — see [[migration-path]]).
4. **Wire up observability before launch**, not after. Logs, metrics, and alerts on the key signals,
   so you'd *know* if it broke. Define what "healthy" looks like.
5. **Communicate.** Note what's shipping, when, the risks, and who's on point if it misbehaves.
6. **Watch after release.** Don't deploy and walk away — monitor the signals through the rollout and
   be ready to halt or roll back.
7. **Update docs and changelog** so users and teammates know what changed.

## Common Rationalizations

- "It worked in staging." — Staging isn't production data, scale, or config; verify and watch the real thing.
- "We can roll back if needed." — Only if rollback exists and you've confirmed it works — test it first.
- "Add monitoring later." — Without it you're blind exactly when something's going wrong.
- "Just ship it to everyone." — A canary turns a potential outage into a contained blip.

## Red Flags

- Deploying straight to 100% with no flag or canary
- No tested rollback, or a rollback that can't undo data changes
- No alerting/metrics on the new behavior
- "Deploy and move on" with nobody watching
- Users learning about the change from breakage

## Verification

- [ ] Verified in a production-like environment; config/secrets ready
- [ ] Gradual rollout planned (flag/canary/staged)
- [ ] Rollback exists, is documented, and was tested — data effects included
- [ ] Monitoring/alerting on key signals is live before launch
- [ ] Change communicated; an owner is watching during rollout
- [ ] Docs/changelog updated
