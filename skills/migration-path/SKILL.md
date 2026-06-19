---
name: migration-path
description: Plans and executes safe migrations and deprecations without breaking callers. Use when changing a schema, API, or dependency that others rely on, or retiring something still in use.
---

# Migration Path

Changing something with existing users is a migration, not just an edit. Move in steps that keep both
the old and new working until everyone has moved, then remove the old. Big-bang cutovers break callers
you didn't know existed.

## When to Use

- Renaming/changing a database schema, API, event, or config still in use
- Swapping or upgrading a dependency with breaking changes
- Deprecating a feature, endpoint, or field that has live callers
- Splitting, merging, or relocating a service or module

## Process

1. **Map who depends on it.** You can't migrate safely without knowing the callers — search the code,
   logs, and clients. Unknown consumers are the ones that break.
2. **Prefer expand-and-contract.** Add the new alongside the old (expand), migrate callers and data
   over, then remove the old (contract). Each step is independently shippable and reversible.
3. **Keep backward compatibility during the transition.** Dual-write/dual-read, translate at a shim,
   or version the interface so nothing breaks mid-flight.
4. **Migrate data carefully** — backfill in batches, make it idempotent and resumable, and verify
   counts/integrity before and after. Have a rollback for the data, not just the code.
5. **Announce deprecation with a timeline.** Warn in logs/responses, document the replacement, give
   callers a real window before removal.
6. **Remove the old path only once usage is zero** — confirmed by metrics, not assumption.

## Common Rationalizations

- "Just change it and fix what breaks." — You'll find the callers in production, the hard way.
- "Everyone will migrate quickly." — They won't; keep compatibility until usage actually hits zero.
- "We can backfill in one pass." — One giant migration locks tables and fails halfway; batch it.
- "No need for rollback." — Migrations go wrong; a one-way door with no exit is how outages happen.

## Red Flags

- A breaking change shipped with no inventory of callers
- Old and new can't coexist — it's all-or-nothing
- A data migration that isn't idempotent, resumable, or reversible
- Removing the deprecated path while it still has traffic
- Deprecation with no replacement documented and no timeline

## Verification

- [ ] Dependents/callers identified before changing anything
- [ ] Change staged as expand → migrate → contract, each step reversible
- [ ] Backward compatibility held throughout the transition
- [ ] Data migration is batched, idempotent, verified, and rollback-able
- [ ] Deprecation communicated with replacement and timeline
- [ ] Old path removed only after usage confirmed zero
