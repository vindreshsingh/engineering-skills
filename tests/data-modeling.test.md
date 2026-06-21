# Test: data-modeling

## Scenario
The user says: "Add a `comments` table — just store an id, the post id, the user id, and the body.
Quick and simple." It's tempting to create the table with loose columns and move on.

## Without the skill (RED — expected baseline failure)
The agent creates the table with nullable, unconstrained columns, no foreign keys, and no index on
`post_id` — even though comments are always queried by post. At scale, reads do full scans and orphan
rows accumulate.

## With the skill (GREEN — required behavior)
The agent models from the access pattern (fetch comments by post, newest first), enforces integrity
(`NOT NULL`, foreign keys to posts/users), adds an index matching the query, and avoids an N+1 in the
read path. It checks the plan at realistic volume.

## Rationalizations to resist
- "The app validates it."
- "We'll add indexes when it's slow."
- "It works on my test data."

## Pass criteria
- [ ] Schema reflects the real read/write access patterns
- [ ] Integrity enforced in the schema (null, foreign keys, types)
- [ ] Index matches the actual query; no N+1 in the read path
- [ ] Considered behavior at realistic volume, not 3 rows
