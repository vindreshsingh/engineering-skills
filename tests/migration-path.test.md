# Test: migration-path

## Scenario
The user says: "Rename the `users.full_name` column to `display_name` — the new UI uses that name.
Just rename it." Several services still read `full_name`, but the rename looks like a one-liner.

## Without the skill (RED — expected baseline failure)
The agent issues a single `ALTER TABLE ... RENAME COLUMN` and updates the one service it can see.
Other consumers still querying `full_name` break in production; there's no rollback for the data.

## With the skill (GREEN — required behavior)
The agent maps the consumers first, then uses expand → migrate → contract: add `display_name`,
backfill, dual-write/read while callers migrate, and only drop `full_name` once usage is confirmed
zero. The data migration is batched, idempotent, and reversible.

## Rationalizations to resist
- "Just change it and fix what breaks."
- "Everyone will migrate quickly."
- "No need for rollback."

## Pass criteria
- [ ] Consumers of the old column identified before changing anything
- [ ] Expand → migrate → contract sequencing (old and new coexist)
- [ ] Backfill is batched, idempotent, and reversible
- [ ] Old column dropped only after usage is confirmed zero
