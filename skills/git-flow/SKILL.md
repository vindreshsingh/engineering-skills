---
name: git-flow
description: Sound git practice — focused commits, clear messages, clean branches, safe history. Use when committing, branching, opening or updating a PR, merging, resolving conflicts, cutting a release, or recovering from a git mistake.
---

# Git Flow

Version control is a record other people (and future you) read to understand **why** the code is the way
it is. Commits should be small, focused, well-described, and safe to share. History should be
**bisectable** for [[fault-recovery]], **reviewable** for [[review-gate]], and **revertible** for
[[launch-readiness]] — a wall of WIP in one commit defeats all three.

Follow the **project's** merge and branch conventions when they exist. This skill is the baseline when
none are defined.

Pairs with [[incremental-delivery]] for commit-sized slices, [[pipeline-ops]] for CI before merge,
[[review-gate]] before opening a PR, [[launch-readiness]] for release tags and rollback, and
[[hardening]] for never committing secrets.

## When to Use

- Starting work on a feature, fix, or refactor
- Committing — especially before end of day or context switch
- Opening, updating, or merging a pull request
- Rebasing, merging, or resolving conflicts with `main`
- Cutting a release tag or hotfix branch
- Recovering from a bad commit, lost work, wrong merge, or accidental force-push panic
- Establishing branch and commit conventions for a team

Skip heavy ceremony for trivial one-line fixes — still write a real message and run checks if the repo
requires them.

## Process

### 1. Branch from the right base

- Branch off the **latest** integration branch (`main`, `master`, `develop` — whatever the project uses).
- **Pull or fetch** before creating the branch — don't branch from stale local `main`.
- **Name for the work**, not the person:

```text
feature/add-guest-checkout
fix/null-total-on-empty-cart
chore/upgrade-eslint-9
hotfix/payment-422-regression
```

- Keep branches **short-lived** — days, not months. Long drift makes merges painful and review huge.
- One logical initiative per branch. Don't pile unrelated fixes onto a feature branch "while you're here."

### 2. Commit in small, working slices

Each commit should be **one logical change** that leaves the tree in a working state
([[incremental-delivery]]):

| Good single commit | Bad bundled commit |
|--------------------|-------------------|
| Add `TaxService` + tests | Feature + refactor + lint fix + dependency bump |
| Fix null cart in `OrderSummary` | "WIP" with 40 files |
| Revert broken deploy | Revert + new feature in same commit |

**Commit at green** — tests and lint pass for what you changed. Don't commit known-broken intermediate
state unless the team explicitly uses stacked PRs / draft WIP on a private branch.

Before each commit:

```bash
git status
git diff          # review what you're about to record
# run relevant tests / lint per project norms
```

Separate **refactor** from **behavior change** when possible — reviewers and `git bisect` depend on it.

### 3. Write commits that explain why

The diff shows **what** changed. The message owns **why**.

**Format:**

```text
Short imperative subject (~50 chars, no period)

Optional body: context, trade-offs, ticket link, what you rejected.
Wrap at ~72 chars.

Fixes #123
```

**Subject examples:**

```text
Add idempotency key to order creation endpoint
Fix race in session refresh when tab wakes from sleep
Revert "cache user permissions globally"
```

**Avoid:** `fix`, `wip`, `stuff`, `asdf`, `misc`, `address comments` (say what changed instead).

**Body when needed:**

- Why this approach vs alternatives ([[decision-docs]] pointer if major)
- Non-obvious constraint or rollback note
- Migration or deploy ordering ("requires migration 0042 first")

Reference tickets (`Fixes #`, `Refs #`) so history links to issue context.

### 4. Never commit noise or secrets

Before every commit, scan the diff for:

- **Secrets** — API keys, tokens, `.env`, credentials ([[hardening]]). If leaked: rotate the secret;
  removing from git isn't enough.
- **Generated artifacts** — `dist/`, `node_modules/`, `__pycache__/`, build output (use `.gitignore`).
- **Large binaries** — use LFS or external storage if truly needed.
- **Debug leftovers** — `console.log`, commented code blocks, temporary flags.

Keep `.gitignore` current when new tooling adds output dirs. Use `git check-ignore` to verify.

If secrets hit shared history, treat as incident — rotate credentials and consider history rewrite only
with team coordination (rare and painful).

### 5. Prepare a PR for review

Before opening:

1. **Self-review the full diff** ([[review-gate]]) — you'd catch half the comments yourself.
2. **Rebase or merge** latest `main` — resolve conflicts locally, re-run CI.
3. **CI green** on your branch ([[pipeline-ops]]).
4. **PR description** — what, why, how to test, screenshots for UI, rollout/rollback notes if risky
   ([[launch-readiness]], [[migration-path]]).
5. **Scope** — if the PR grew too large, split ([[incremental-delivery]]).

Update the PR as you push new commits; don't open "empty" and fill in description days later.

### 6. Merge and integrate — follow project convention

Teams differ; **don't improvise** on a shared repo:

| Strategy | When teams use it | Notes |
|----------|-------------------|-------|
| **Merge commit** | Preserve branch history | Clear merge point; busier log |
| **Squash merge** | One commit per PR on `main` | Clean `main`; detail lives in PR |
| **Rebase merge** | Linear `main` | Rewrites branch commits onto tip |

**Updating your branch with latest `main`:**

- **Rebase** (`git rebase origin/main`) — linear history; only on **your** feature branch before merge.
- **Merge** (`git merge origin/main`) — preserves branch history; safer if others push to your branch.

Never rebase a branch others are actively committing to without agreement.

**After merge:** delete the feature branch (remote + local) to reduce clutter.

### 7. Resolve conflicts deliberately

When merge/rebase stops with conflicts:

1. **Understand both sides** — don't blindly accept yours or theirs.
2. Open conflicted files; read `<<<<<<<` markers and **integrate intent**, not just syntax.
3. Run **tests** after resolution — conflict markers removed isn't the same as correct merge.
4. `git add` resolved files; continue merge/rebase.

If conflicts are huge, the branch may have drifted too long — consider rebasing earlier next time or
splitting the PR.

### 8. Keep history safe on shared branches

**Never force-push** (`git push --force`) to branches others build on — `main`, shared feature branches,
release branches. It rewrites their base and can destroy unpushed work.

**Safe to rewrite** — your local-only branch, or your feature branch before anyone else pulled it (and
team allows force-with-lease on feature branches).

Prefer:

- **`git revert`** on `main` — adds a commit that undoes a bad one; safe for shared history.
- **`git restore`** / **`git checkout --`** — discard unstaged or uncommitted local changes.
- **`git reflog`** — recover "lost" commits after mistaken reset (local).

If you must undo a pushed commit on a shared branch, **revert** — don't reset and force-push.

### 9. Recover from mistakes

**Uncommitted work in wrong direction**

```bash
git stash push -m "describe work"
# or commit on a throwaway branch before experimenting
```

**Wrong files staged**

```bash
git restore --staged <file>
git restore <file>              # discard working copy if needed
```

**Last commit wrong but not pushed**

```bash
git commit --amend              # only if HEAD is yours and not pushed shared
```

**Last commit pushed to shared `main`**

```bash
git revert <bad-commit-sha>     # new commit that undoes it — don't force-push main
```

**Lost commit after reset**

```bash
git reflog
git checkout -b recovery <sha-from-reflog>
```

**Cherry-pick** one fix onto another branch:

```bash
git cherry-pick <sha>
```

**Panic rule:** stop before `push --force`; check `git status`, `git log`, and whether others use the
branch.

### 10. Releases, tags, and hotfixes

**Releases** ([[launch-readiness]]):

- Tag `main` at the release point — `v1.4.0`, annotated message with changelog highlights.
- Release branches (`release/1.4`) if the project maintains patch lines.

**Hotfixes:**

1. Branch from the **tag or release branch** that production runs — not from random `main` tip if
   they've diverged.
2. Minimal fix + test; fast review.
3. Merge back to `main` and release branch so the fix isn't lost on next deploy.
4. Tag patch release (`v1.4.1`).

Document deploy order if migrations or config must land first ([[migration-path]]).

### 11. Scenario playbooks

**Start a feature**

Fetch → branch from latest `main` → small commits at green → push early for backup.

**PR feedback**

One commit per logical feedback round (or squash locally if team squashes on merge). Reply on threads;
don't force-push without re-running CI.

**Long-running branch**

Merge or rebase `main` weekly minimum; smaller PRs upstream reduce pain.

**CI failed after push**

Reproduce locally → fix → one commit → push. Don't pile unrelated fixes.

**Accidentally committed secret**

Rotate secret immediately → remove from tree → never commit the new secret → team process for history
if the old one was pushed.

**Need to undo merged PR on `main`**

`git revert` the merge commit (may need `-m 1` for merge commits) → deploy revert → fix forward in
new PR.

**Experimental spike**

Branch `spike/name` — may be messy locally; don't merge without cleaning history or squash per convention.

## Common Rationalizations

- "I'll squash it all into one big commit." — A wall-of-changes commit is unreviewable and unbisectable.
- "The message can just be 'fix'." — Useless later; the why is what the reader needs.
- "Force-push is fine." — On a shared branch it rewrites everyone else's base and loses work.
- "I'll commit everything at the end." — Huge diffs hide mistakes and make rollback all-or-nothing.
- "Rebase is always better." — Only on your branch; rebase shared branches without agreement causes pain.
- "I'll amend the pushed commit." — Amending pushed commits on shared branches requires force-push.
- "`.gitignore` will catch it later." — Review the diff; ignored files don't help if already tracked.
- "Conflicts resolved — good enough." — Run tests; conflict resolution bugs ship often.

## Red Flags

- Commits titled `wip`, `fix`, `stuff`, or `asdf`
- Single commit mixing unrelated refactor, feature, and dependency bump
- Secrets, build output, or large binaries in history
- Force-pushing `main`, `master`, or a branch others use
- Long-lived branches hundreds of commits behind `main`
- PR opened with no description or test plan
- Merging with failing CI or unresolved conflicts
- Revert needed but team force-pushed instead
- Hotfix only on production branch, never merged back to `main`
- Amending commits others already pulled

## Verification

- [ ] Branch named for work, created from latest integration branch
- [ ] Each commit is one logical, working change ([[incremental-delivery]])
- [ ] Messages: imperative subject + why in body when non-obvious; ticket linked
- [ ] Diff reviewed — no secrets, artifacts, debug noise ([[hardening]])
- [ ] PR self-reviewed, description complete, CI green ([[review-gate]], [[pipeline-ops]])
- [ ] Merge/rebase strategy matches project convention; conflicts resolved and tested
- [ ] Shared history not rewritten — revert used on shared branches, not force-push
- [ ] Feature branch deleted after merge; hotfix merged back to `main` if applicable
- [ ] Release tagged and documented when shipping ([[launch-readiness]])
