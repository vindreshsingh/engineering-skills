---
name: data-modeling
description: Designs data schemas and queries that stay correct and fast as data grows. Use when creating or changing a database schema, designing tables/collections, adding indexes, or fixing slow queries.
---

# Data Modeling

The data model outlives the code that uses it and is the most expensive thing to change later. Model
for how the data is actually read and written, enforce integrity in the schema, and index for the
queries you run — before the table has millions of rows.

## When to Use

- Designing a new table, collection, or schema
- Adding fields, relationships, or changing types on existing data
- Writing or reviewing queries, especially in hot paths
- Diagnosing slow queries, lock contention, or growth problems

## Process

1. **Model from the access patterns.** Know the main reads and writes first; the right shape for a
   read-heavy lookup differs from a write-heavy log. Don't model in the abstract.
2. **Enforce integrity in the schema**, not just the app: correct types, `NOT NULL`, unique
   constraints, foreign keys/relationships. The database is the last line of defense for valid data.
3. **Normalize by default; denormalize deliberately.** Start normalized to avoid update anomalies;
   denormalize only for a measured read-performance need, accepting the consistency cost.
4. **Index for your queries — and only those.** Add indexes that match real `WHERE`/`JOIN`/`ORDER BY`
   patterns; every index speeds reads but slows writes and costs space, so don't over-index.
5. **Kill N+1 access.** Fetch related data in a set (join/batch), not a query per row in a loop
   ([[perf-budget]]).
6. **Plan for growth and change.** Pagination/limits on unbounded results, a strategy for big tables,
   and migrations that are backward-compatible ([[migration-path]]).
7. **Verify with realistic volume.** Check the query plan and behavior at expected scale, not on three
   test rows.

## Common Rationalizations

- "The app validates it." — App checks are bypassable and racy; constraints in the DB are not.
- "We'll add indexes when it's slow." — By then it's slow in production under load; index for known queries up front.
- "Denormalize, it's faster." — Until duplicated data drifts out of sync and corrupts reads.
- "It works on my test data." — Three rows hide the full scans and lock contention that appear at scale.

## Red Flags

- Nullable columns and no constraints carrying critical invariants
- A query per row inside a loop (N+1)
- No index on a column used in frequent `WHERE`/`JOIN`
- Indexing everything "to be safe," slowing writes
- Unbounded queries with no pagination
- Schema changes shipped with no backward-compatible migration

## Verification

- [ ] Schema designed around real read/write access patterns
- [ ] Integrity enforced in the schema (types, null, unique, foreign keys)
- [ ] Normalized by default; any denormalization is justified and consistency-managed
- [ ] Indexes match actual queries; no needless ones slowing writes
- [ ] No N+1; related data fetched in sets; unbounded results paginated
- [ ] Verified against realistic data volume and query plans
