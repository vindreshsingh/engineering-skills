# Before / After: `hardening`

**Task:** "Add an endpoint so a logged-in user can download one of their uploaded files by id."

## Without the skill (rushed)

The happy path works, so it ships:

```ts
app.get("/files/:id", requireAuth, async (req, res) => {
  const file = await db.files.findById(req.params.id);
  res.sendFile(file.path);
});
```

`requireAuth` is present, so it *feels* secure. It isn't:

- **IDOR:** any logged-in user can read *anyone's* file — `id` is never checked against `req.user`.
  Authentication ≠ authorization.
- **Path traversal:** `file.path` is trusted; if an id ever maps to `../../etc/passwd`, it's served.
- **Info leak:** a missing file throws, returning a stack trace.

The endpoint passes review when review only checks "does it work."

## With the skill (`hardening`)

A security pass over the diff catches each of these and closes them:

```ts
app.get("/files/:id", requireAuth, async (req, res) => {
  const file = await db.files.findById(req.params.id);

  // Authorization: the resource must belong to the caller (closes IDOR).
  if (!file || file.ownerId !== req.user.id) {
    return res.status(404).json({ error: "Not found" }); // 404, not 403 — don't leak existence
  }

  // Never trust a stored path: resolve and confine to the uploads root (closes traversal).
  const root = path.resolve(UPLOADS_DIR);
  const resolved = path.resolve(root, path.basename(file.path));
  if (!resolved.startsWith(root + path.sep)) {
    return res.status(400).json({ error: "Invalid file" });
  }

  res.sendFile(resolved);
});
```

## Why it's better

`hardening` turns "it works" into "it's safe to expose." The IDOR — the single most common real-world
web vulnerability — is closed by checking *authorization per resource*, not just authentication; path
traversal is contained; and errors don't leak existence or stack traces. Pair it with
[`threat-modeling`](../../skills/threat-modeling/SKILL.md) at design time to catch these *before* the
code is written, and [`test-first`](test-first.md) to lock the authz rule with a test.
