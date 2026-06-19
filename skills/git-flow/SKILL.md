---
name: git-flow
description: Sound git practice — focused commits, clear messages, clean branches, safe history. Use when committing, branching, merging, resolving conflicts, or recovering from a git mistake.
---

# Git Flow

Version control is a record other people (and future you) read to understand why the code is the way
it is. Make commits that tell that story: small, focused, well-described, and safe to share.

## When to Use

- Committing work, branching, or preparing a PR
- Merging, rebasing, or resolving conflicts
- Recovering from a bad commit, lost work, or a tangled history
- Establishing branch/commit conventions for a project

## Process

1. **One logical change per commit.** A commit should do a single thing and leave the tree working.
   Don't bundle a refactor, a feature, and a fix together ([[incremental-delivery]]).
2. **Write a real message.** A concise subject in the imperative ("Add token refresh"), then a body
   explaining *why* and any non-obvious trade-offs. The diff shows *what*; the message owns *why*.
3. **Branch off the latest base**, named for the work. Keep branches short-lived to avoid drift.
4. **Don't commit noise.** No secrets, generated artifacts, large binaries, or debug leftovers; that's
   what `.gitignore` is for.
5. **Keep history readable.** Clean up local WIP commits before sharing; prefer fast-forward or tidy
   merges per the project's convention.
6. **Rewrite only unpushed/local history.** Never force-push shared branches others build on.
7. **Recover calmly.** `git reflog`, `revert`, `restore`, and `stash` undo most mistakes; prefer
   `revert` over force-pushing a shared branch.

## Common Rationalizations

- "I'll squash it all into one big commit." — A wall-of-changes commit is unreviewable and unbisectable.
- "The message can just be 'fix'." — Useless later; the why is exactly what the reader needs.
- "Force-push is fine." — On a shared branch it rewrites everyone else's base and loses work.
- "I'll commit everything at the end." — Huge diffs hide mistakes and make rollback all-or-nothing.

## Red Flags

- Commits titled "wip", "fix", "stuff", or "asdf"
- A single commit mixing unrelated changes
- Secrets, build output, or huge binaries in history
- Force-pushing a branch others are using
- Long-lived branches that drift far from main

## Verification

- [ ] Each commit is one logical, working change
- [ ] Messages have a clear imperative subject and explain why
- [ ] No secrets/artifacts committed; `.gitignore` is doing its job
- [ ] Branch is named for the work and based on the latest main
- [ ] Shared history wasn't rewritten; recovery used revert/reflog, not force-push
