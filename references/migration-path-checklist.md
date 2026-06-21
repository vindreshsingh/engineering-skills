# Migration Path Checklist

Quick reference alongside [[migration-path]].

## Planning

- [ ] Callers/consumers identified
- [ ] Backward-compatible phase planned
- [ ] Deploy order documented (schema → API → clients)
- [ ] Rollback limits defined (data rollback possible?)

## Execution

- [ ] Expand schema compatible with old + new code
- [ ] Dual-write or backfill if needed — batched, monitored
- [ ] Feature flag for new path
- [ ] Old path usage metrics before removal

## Communication

- [ ] Deprecation notice with timeline
- [ ] Migration guide for integrators ([[technical-writing]])
- [ ] ADR if architectural ([[decision-docs]])

## Completion

- [ ] Old path usage at zero
- [ ] Contract phase: remove deprecated code
- [ ] Verify no orphaned data
