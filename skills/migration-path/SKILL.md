---
name: migration-path
description: Plans and executes safe migrations and deprecations without breaking callers. Use when changing a schema, API, event, dependency, or config that others rely on, or retiring a feature, endpoint, or field still in use.
---

# Migration Path

Changing something with **existing consumers** is a migration, not an edit. Big-bang cutovers break
callers you didn't know existed — mobile apps on old versions, scripts, partner APIs, queued messages,
and "temporary" integrations that became permanent.

Move in steps that keep **old and new working together** until everyone has moved, then **contract**
(remove the old). Each step should be independently shippable and as reversible as your data model
allows.

Pairs with [[interface-design]] for contract evolution, [[data-modeling]] for schema and backfills,
[[launch-readiness]] for deploy order and rollback limits, [[incremental-delivery]] for slice-sized
migration steps, [[dependency-hygiene]] for breaking dependency upgrades, [[git-flow]] for staged
commits, and [[decision-docs]] for deprecation timelines and ADRs.

## When to Use

- Renaming or changing database schema, columns, types, or constraints
- Changing HTTP/RPC APIs, GraphQL fields, or public library signatures
- Evolving event/message/webhook payload schemas
- Deprecating features, endpoints, config keys, or UI flows
- Upgrading dependencies with breaking changes — follow [[version-upgrade]]; use [[migration-path]] if
  your contracts or callers are affected
- Splitting, merging, or relocating services or modules
- Data repair, backfill, or re-encoding at scale

Skip for purely internal code with **no external callers** and no persisted data depending on the old
shape — still document if the "internal" surface is wide. Skip one-off data fixes on tables with no
live readers if truly isolated.

## Process

Work in order. Inventory before edit.

### 1. Map who depends on it — assume unknown consumers exist

You can't migrate safely without knowing **who breaks** when you change:

| Source | What to find |
|--------|--------------|
| **Codebase** | grep, importers, OpenAPI clients, shared packages |
| **Repos you don't own** | Mobile apps, partner integrations, data pipelines |
| **Logs / metrics** | Traffic on endpoint, field usage, event consumers |
| **Queues / topics** | Downstream subscribers, replay tools |
| **Config** | Env vars read by other services or deploy scripts |
| **Docs / runbooks** | External references to old names |

**Unknown consumers** are the ones that break at 2am. Search aggressively; ask teams; check API
analytics. If you can't find callers, **assume they exist** and keep compatibility longer.

Document the **dependency inventory** in the PR or migration doc — who, what version, owner contact.

### 2. Prefer expand → migrate → contract

The default pattern for schema and contracts ([[data-modeling]], [[interface-design]]):

```text
EXPAND   — add new alongside old (nullable column, new endpoint, dual field)
MIGRATE  — move callers and data to new path (backfill, client updates, dual-read/write)
CONTRACT — remove old only when usage is zero (drop column, delete endpoint, remove field)
```

Each phase is a **separate deploy** when possible ([[incremental-delivery]], [[launch-readiness]]).

**Never contract in the same release as expand** unless traffic is truly zero.

| Layer | Expand | Migrate | Contract |
|-------|--------|---------|----------|
| **DB column** | Add `new_col` nullable | Backfill; app writes both | Drop `old_col` |
| **API field** | Add `emailAddress`; keep `email` | Clients read new; dual-write | Remove `email` |
| **Endpoint** | Ship `/v2/orders` | Route traffic; deprecate v1 | Remove v1 at zero traffic |
| **Event** | New `schemaVersion: 2` optional fields | Consumers handle both | Stop v1 publish |
| **Config** | New key with default from old | Services read new | Remove old key |

### 3. Keep backward compatibility during transition

Pick strategies that match risk and duration:

| Strategy | When | Notes |
|----------|------|-------|
| **Dual-write** | Rename/move data | Write old + new; verify parity |
| **Dual-read** | Prefer new, fallback old | Until backfill complete |
| **Shim / adapter** | Old API surface must persist | Translate at boundary |
| **API versioning** | External clients slow to update | `/v1` + `/v2` coexist |
| **Feature flag** | Behavior switch | Off = old path ([[launch-readiness]]) |
| **Shadow write** | Test new path | Write new without reading yet |

**Compatibility window** — explicit end date or usage threshold, not "eventually."

Old and new must **coexist in production** without requiring simultaneous deploy of all services unless
you control every caller and can coordinate a maintenance window.

### 4. Migrate data carefully — batch, verify, resume

Data migrations are where rollbacks die ([[data-modeling]]):

**Rules:**

- **Expand first** — additive schema before backfill; app tolerates null/missing new fields
- **Batch** — thousands–millions of rows per chunk; not one giant transaction
- **Idempotent** — safe to re-run job (`WHERE new_col IS NULL LIMIT n`)
- **Resumable** — track progress; survive worker crash
- **Off-peak** for heavy writes — lock and replication lag awareness
- **Verify** — row counts, checksums, sample diffs before/after
- **Throttle** — don't overwhelm DB or downstream ([[resilience]])

```sql
-- Pattern: repeated until zero rows updated
UPDATE orders SET new_status = map_old_status(old_status)
WHERE new_status IS NULL
LIMIT 5000;
```

**Destructive transforms** (delete, narrow type) — extra caution; often **copy to new table** then
swap, not in-place mutate.

Document **data rollback**: often forward-fix only — design expand-contract so contract happens only
after confidence.

### 5. Deploy order — sequence releases

Wrong order = outage mid-deploy ([[launch-readiness]]):

```text
Typical safe sequence:
1. Deploy migration EXPAND (backward compatible)
2. Deploy app that reads/writes BOTH or new-only with nullable expand
3. Run backfill job; monitor
4. Deploy app that reads NEW only (still writes both if dual-write)
5. Deploy app write NEW only
6. Later: CONTRACT migration (drop old) — separate release
```

**Mobile / external clients** — server must stay backward-compatible until app store adoption catches up.

Document in release notes: **"Requires migration 0042 before app 2.5.0."**

### 6. Deprecate with timeline and telemetry — don't surprise

Before removal:

- **Document replacement** — migration guide, not "use the new one"
- **Warn in API** — `Deprecation` header, sunset date, `Sunset` RFC 8594 where applicable
- **Log** deprecated path usage at sample rate — know who's left
- **Metrics** — traffic on old endpoint/field; dashboard until zero
- **Communicate** — owners of known consumers; support brief

```http
Deprecation: true
Sunset: Sat, 01 Jan 2027 00:00:00 GMT
Link: </v2/orders>; rel="successor-version"
```

**Minimum deprecation window** — proportional to client control (internal week, external quarter+).

Record in [[decision-docs]] when policy affects many teams.

### 7. Contract only at zero — metrics, not assumption

Remove old path when:

- [ ] **Traffic / usage** at zero (or agreed threshold) for sustained period
- [ ] **No known callers** remain — inventory rechecked
- [ ] **Backfill complete** and verified for data migrations
- [ ] **Contract migration** tested in staging — app still boots without old column/field
- [ ] **Rollback plan** for contract — usually forward-fix; acknowledged

Contract PR is intentionally boring — delete dead code, drop column, remove flag default old path.

### 8. Rollback reality — code vs data

| Change | Code rollback | Data rollback |
|--------|---------------|---------------|
| Feature flag OFF | Easy | N/A |
| Revert deploy | Easy if no migration | Old code may not match new data |
| Expand migration | N/A | Usually harmless to leave extra column |
| Backfill | N/A | Often **not** reversible — plan forward fix |
| Contract (drop column) | Hard | **Very hard** — avoid until certain |

**Test rollback in staging** before high-tier launch ([[launch-readiness]]):

- Deploy forward → verify → revert app → verify old behavior
- If revert fails, migration design is wrong for zero-downtime

### 9. Scenario playbooks

**Rename database column**

Add `new_name` → dual-write in app → backfill → read new → write new only → drop `old_name`.

**Add required field to API**

Phase 1: optional in API + DB nullable → clients updated → Phase 2: required in API → Phase 3: DB
NOT NULL after backfill.

**Split monolithic table**

New table + dual-write → backfill historical → migrate reads → stop writes to old → archive old table.

**API v2 for external partners**

v2 live with v1 → partner migration deadline → metric on v1 → sunset headers → remove v1.

**Event schema v2**

Publish v2 events with `schemaVersion`; consumers dual-handle → migrate consumers → stop v1 publish →
retire old consumer code.

**Breaking dependency major** ([[dependency-hygiene]])

Inventory imports → upgrade in branch slices → compat shim if needed → remove shim after callers updated.

**Extract service from monolith**

Define API matching old in-process calls → route one caller at a time → strangle monolith module →
delete in-process path when zero.

**Feature deprecation (UI + API)**

Flag default off → metric on usage → remove UI → API deprecated headers → remove API when zero.

**Config key rename**

Read new with fallback to old → deploy all readers → deploy writers to new only → remove old key from
config store.

**Emergency data repair**

Stop harmful writes → scope rows affected → idempotent repair script in batches → verify counts →
postmortem + guardrail ([[incident-response]]).

## Common Rationalizations

- "Just change it and fix what breaks." — Callers surface in production, the hard way.
- "Everyone will migrate quickly." — Mobile, partners, and scripts won't; measure usage.
- "We can backfill in one pass." — Giant jobs lock tables and fail halfway; batch.
- "No need for rollback." — Migrations go wrong; one-way doors cause outages.
- "We'll deprecate later." — Later never comes; usage becomes permanent.
- "Internal API — no migration needed." — Internal becomes external; other teams depend on you.
- "Dual-write is overkill." — It's cheaper than reconciling corrupted dual worlds after a bad cutover.
- "Contract now — column is unused." — Verify with metrics, not grep once.

## Red Flags

- Breaking change with no caller inventory
- Expand and contract in same release
- Data migration not idempotent or resumable
- Backfill without before/after count verification
- Removing deprecated API with traffic still on it
- Deprecation with no replacement doc or sunset date
- Deploy code that requires new schema before migration runs
- No metrics on old path — "we think nothing uses it"
- Dual-write without parity check before dropping old write
- Contract migration with no staging test of app on new-only schema
- Dependency major upgraded without caller sweep
- "Rollback" = hope when data was destructively transformed

## Verification

- [ ] Dependents inventoried — code, logs, metrics, external clients documented
- [ ] Plan is expand → migrate → contract with separate shippable steps ([[incremental-delivery]])
- [ ] Backward compatibility strategy chosen — dual-read/write, version, shim, flag
- [ ] Data migration batched, idempotent, resumable, verified ([[data-modeling]])
- [ ] Deploy order documented and matches launch plan ([[launch-readiness]])
- [ ] Deprecation communicated — replacement, timeline, API warnings ([[decision-docs]])
- [ ] Usage metrics on old path until removal
- [ ] Rollback tested for code; data limits documented honestly
- [ ] Contract phase only after zero (or threshold) usage confirmed
- [ ] Post-removal: docs, clients, flags, and dead code cleaned up
