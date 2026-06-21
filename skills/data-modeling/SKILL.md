---
name: data-modeling
description: Designs data schemas and queries that stay correct and fast as data grows. Use when creating or changing a database schema, designing tables/collections, adding indexes, fixing slow queries, planning backfills, or choosing how data is stored and accessed at scale.
---

# Data Modeling

The data model outlives the code that uses it and is the most expensive thing to change later. A schema
designed in the abstract — "normalized because textbooks say so" or "denormalized because it's faster" —
breaks under real load or corrupts data under concurrent writes. Model from **how the data is actually
read and written**, enforce integrity where the database can, index for the queries you run, and verify
before the table has millions of rows.

Pairs with [[migration-path]] for schema changes in production, [[perf-budget]] to measure before and
after query work, [[interface-design]] for API/event shapes that expose the model, [[caching-strategy]]
only after the query and indexes are right, and [[hardening]] when modeling auth, tenancy, or sensitive
fields.

## When to Use

- Designing a new table, collection, index, or schema
- Adding fields, relationships, types, or constraints on existing data
- Writing or reviewing queries — especially in hot paths, loops, or batch jobs
- Diagnosing slow queries, lock contention, table bloat, or growth problems
- Planning a backfill, deduplication, or archival strategy for large tables
- Choosing between relational, document, columnar, or event-log storage for a workload

Skip as the primary skill for pure application logic with no persistence change. Still apply if the
change affects query patterns, N+1 in ORMs, or data passed to callers.

## Process

Work in order. Later steps assume access patterns are written down.

### 1. Document access patterns first

Before drawing tables, list the **reads and writes** the feature needs. For each, note:

| Question | Why it matters |
|----------|----------------|
| How often? (per second, per day, batch) | Drives indexing and denormalization |
| Latency target? (interactive vs background) | Drives cache vs query shape |
| Consistency need? (exact vs eventually OK) | Drives denormalization and replicas |
| Cardinality? (one row, thousands, millions) | Drives pagination and partition strategy |
| Who calls it? (API, job, report, admin) | Drives separate read models if needed |

```text
Read: order by id for checkout UI — ~500/s, p95 < 50ms, exact, 1 row
Read: user's recent orders — ~200/s, p95 < 100ms, exact, 20 rows paginated
Write: create order — ~50/s, must be atomic with inventory decrement
Batch: daily revenue by region — nightly, minutes OK, approximate OK
```

If you can't list patterns, you're not ready to model. Decompose the feature ([[work-planning]]) until
each step has concrete data access.

### 2. Model entities, keys, and relationships

- **Entities** map to real domain concepts — not to every screen field on one wide row.
- **Primary keys:** prefer stable **surrogate keys** (UUID, bigint) for mutable business identifiers.
  Natural keys (email, SKU) belong in unique constraints, not always as PKs.
- **Relationships:** model 1:N with foreign keys; N:M with a join table — don't encode lists in strings
  or JSON unless the store and access pattern truly require it.
- **Ownership:** each row should have a clear owning service or bounded context ([[interface-design]]).
  Shared mutable tables across teams become coupling points.
- **Lifecycle:** decide hard delete vs soft delete (`deleted_at`), archival, and retention up front —
  not when the table is full.

Name tables and columns in the **domain language** used by callers. Consistency beats cleverness.

### 3. Pick a storage shape that fits the workload

Don't default to relational for everything — but don't abandon constraints without a reason.

| Workload | Typical fit | Watch out for |
|----------|-------------|---------------|
| Transactional CRUD, joins, integrity | Relational (PostgreSQL, MySQL) | Over-normalized hot reads |
| Document-shaped reads, flexible schema | Document (MongoDB, Firestore) | Duplicated data without sync story |
| Append-only events, audit, replay | Event log / WAL table | Rebuilding state from events |
| Analytics, aggregates over huge history | Columnar / OLAP / warehouse | Don't run reports on the OLTP primary |
| Full-text, geo, graph traversals | Specialized index or store | Don't fake it in generic JSON |

**Rule:** OLTP (user-facing reads/writes) and heavy analytics usually need **separate paths** — ETL,
CDC, or read replicas — not one schema tortured to serve both.

### 4. Enforce integrity in the schema

The database is the last line of defense. App validation is bypassable, racy, and inconsistent across
callers.

Apply at the schema level:

- **Correct types** — `timestamptz` not string dates; `numeric` for money; bounded `varchar` where it
  helps; `jsonb` only when shape is truly variable and you accept query cost.
- **`NOT NULL`** on fields that must always exist — nullable "optional" columns often become "sometimes
  null" forever.
- **Unique constraints** on natural identifiers (email, external id, slug per tenant).
- **Foreign keys** where referential integrity matters — or an explicit, documented alternative if the
  store doesn't support them.
- **Check constraints** for invariants (`status IN (...)`, `end_date >= start_date`).

```sql
-- Prefer: illegal states rejected by the DB
status TEXT NOT NULL CHECK (status IN ('pending', 'paid', 'cancelled')),
amount_cents BIGINT NOT NULL CHECK (amount_cents >= 0)

-- Not: status TEXT, amount_cents BIGINT — "the app checks it"
```

Sensitive fields (PII, tokens): model **encryption, hashing, or separation** at design time
([[hardening]]). Don't widen a table with sensitive columns "for convenience."

### 5. Normalize by default; denormalize deliberately

**Start normalized** to avoid update anomalies — one copy of truth, consistent updates.

**Denormalize only when:**

- A measured hot read can't meet latency with indexes + a normal join
- The duplicated data is **derived** and has a defined refresh path
- Staleness is acceptable or bounded (see [[caching-strategy]])

When you denormalize, document:

- **Source of truth** — which table/column is authoritative
- **Update path** — transaction, trigger, job, or event that keeps copies in sync
- **Failure mode** — what users see if copies drift

Denormalization without a sync story becomes silent data corruption.

### 6. Index for your queries — and only those

Every index speeds specific reads and **slows every write** on that table (plus storage cost).

1. List the actual `WHERE`, `JOIN`, and `ORDER BY` from step 1.
2. Add indexes that match **leftmost prefix** rules for composites.
3. Consider **covering indexes** when the query only needs indexed columns.
4. Use **partial indexes** when queries always filter the same subset (`WHERE status = 'active'`).
5. **Remove** indexes that no query uses — they still cost writes.

```sql
-- Query: WHERE tenant_id = ? AND created_at > ? ORDER BY created_at DESC
CREATE INDEX idx_orders_tenant_created ON orders (tenant_id, created_at DESC);

-- Not: separate indexes on tenant_id and created_at when the query always uses both
```

Don't index low-cardinality columns alone (boolean flags) unless combined in a composite that matches
a real query. Don't "index everything to be safe."

After adding indexes, **verify the planner uses them** on realistic volume (step 9).

### 7. Write queries that scale

**Kill N+1.** Fetch related data in one round trip — join, `IN (...)` batch, or ORM `include`/`prefetch`.
A query per row in a loop dominates latency at scale ([[perf-budget]]).

**Paginate unbounded results.** Never `SELECT *` from a growing table without a limit.

| Approach | Use when | Avoid when |
|----------|----------|------------|
| **Keyset / cursor** (`WHERE id > ? ORDER BY id LIMIT`) | Large tables, stable sort key | Sort column changes often |
| **Offset** (`OFFSET n`) | Small offsets, admin UIs | Deep pages on huge tables |

**Select only needed columns.** Wide rows multiply I/O and memory — especially with `SELECT *` and
ORM defaults.

**Batch writes** for bulk inserts/updates; avoid per-row commits in loops.

**Lock awareness** on hot rows:

- Keep transactions short; don't hold locks while calling external services.
- For job queues, consider `SKIP LOCKED` / `FOR UPDATE SKIP LOCKED` patterns.
- Split monolithic updates that touch millions of rows into batched chunks ([[migration-path]]).

### 8. Plan for growth and safe change

Schema changes in production are migrations, not edits ([[migration-path]]).

- **Additive first** — new nullable column or new table; deploy before backfill.
- **Backfill in batches** — idempotent, resumable, with progress and row-count verification.
- **Dual-write / dual-read** when renaming or reshaping live data — old and new coexist until cutover.
- **Table size strategy** — partitioning by time/tenant, archival to cold storage, or summary tables
  for history when rows never delete.
- **Connection and pool sizing** — a fast query at scale still fails if every request opens a storm
  of connections.

Never ship a breaking schema change without caller inventory and a rollback story for **data**, not
just code.

### 9. Verify with realistic volume and query plans

"It works on three test rows" hides full table scans, sort spills, and lock queues.

Before claiming done:

1. **Measure** the query on the hot path ([[perf-budget]]) — p50/p95 latency, rows examined vs returned.
2. **Inspect the plan** — `EXPLAIN (ANALYZE, BUFFERS)` in PostgreSQL; equivalent in your engine.
   Look for sequential scans on large tables, bad join order, filesort, missing index use.
3. **Test at expected scale** — seed or sample production-like volume; run the pagination path at
   "page 1000," not just page 1.
4. **Re-check after deploy** — plans shift as statistics change; monitor slow-query logs
   ([[observability]]).

A cache ([[caching-strategy]]) is not a substitute for a bad plan. Fix the query and indexes first.

### 10. Scenario playbooks

**New feature schema**

- Access patterns → entities → constraints → indexes → migrations → verify with seed data at 10×
  expected row count for the hot table.

**Slow query in production**

- Capture the exact SQL, frequency, and latency. EXPLAIN on production stats (or a restored snapshot).
- Check: missing/wrong index, N+1 from ORM, function on indexed column, implicit cast, stale stats,
  lock wait. Fix the dominant cost; measure again.

**Read-heavy, rarely updated**

- Indexes + covering indexes first. Denormalize or materialized view if still slow. Cache last
  ([[caching-strategy]]).

**Write-heavy ingest**

- Minimize indexes during bulk load if safe; batch inserts; consider append-only + async aggregation.
  Don't over-index "just in case."

**Multi-tenant**

- `tenant_id` on every tenant-scoped row; composite indexes **lead with tenant_id**. Never query
  across tenants without an explicit, audited reason. Row-level security or app scoping — pick one
  model and enforce consistently ([[hardening]]).

**Reporting and analytics**

- Don't hammer the primary. Replicate, CDC, or nightly export to an OLAP-friendly schema. Different
  model, different indexes, different SLAs.

**PII and retention**

- Model delete/anonymize paths when the row is created. Retention jobs need indexes too — don't full-scan
  billions of rows nightly without a plan.

## Common Rationalizations

- "The app validates it." — App checks are bypassable and racy; constraints in the DB are not.
- "We'll add indexes when it's slow." — By then it's slow in production under load; index for known queries up front.
- "Denormalize, it's faster." — Until duplicated data drifts out of sync and corrupts reads.
- "It works on my test data." — Three rows hide full scans and lock contention that appear at scale.
- "ORM handles the queries." — ORMs generate N+1 and `SELECT *` by default; read the SQL.
- "OFFSET pagination is fine." — Deep offsets on large tables scan and discard rows you never return.
- "JSON column is flexible." — Flexible until you need to index, constrain, or join on what's inside.
- "We'll backfill in one migration." — Giant updates lock tables and fail halfway; batch and verify.
- "Add a cache." — Stale wrong data from a bad underlying model costs more than a slow query once.

## Red Flags

- Nullable columns and no constraints carrying critical invariants
- A query per row inside a loop (N+1) — in app code or ORM
- No index on columns used together in frequent `WHERE`/`JOIN`/`ORDER BY`
- Indexes that don't match query column order or filter patterns
- Indexing everything "to be safe," slowing writes with no measured read benefit
- Unbounded queries with no pagination or limit
- `SELECT *` on wide tables in hot paths
- Offset pagination on huge tables without acknowledging cost
- Denormalized copies with no documented sync or source of truth
- Schema changes shipped with no backward-compatible migration path
- Analytics/reporting queries running against the OLTP primary under load
- Multi-tenant data without `tenant_id` in indexes for tenant-scoped queries
- PII modeled with no delete/retention path
- Query "optimized" without EXPLAIN or before/after latency numbers

## Verification

- [ ] Read/write access patterns documented with frequency, latency, and consistency needs
- [ ] Entities, keys, relationships, and lifecycle (delete/archive) decided explicitly
- [ ] Storage shape fits the workload; OLTP vs analytics paths separated where needed
- [ ] Integrity enforced in schema — types, NOT NULL, unique, FK/check constraints as appropriate
- [ ] Normalized by default; denormalization justified with source of truth and sync path
- [ ] Indexes match actual queries; composites ordered correctly; no unused indexes added
- [ ] No N+1; related data fetched in sets; results paginated with appropriate strategy
- [ ] Writes batched where bulk; transactions short; hot-row lock risks considered
- [ ] Schema change follows expand/migrate/contract ([[migration-path]]); backfills batched and verified
- [ ] Query plans inspected; latency measured before/after at realistic volume ([[perf-budget]])
- [ ] Tenant scoping and sensitive fields modeled with enforcement ([[hardening]])
- [ ] Cache considered only after query and indexes are sound ([[caching-strategy]])
