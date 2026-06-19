---
name: pipeline-ops
description: Designs reliable CI/CD pipelines and build/test/deploy automation. Use when setting up or fixing CI, adding checks, configuring deploys, or making the pipeline faster and more trustworthy.
---

# Pipeline Ops

CI/CD is the automated gate every change passes through. It should be fast, deterministic, and
trustworthy: green means safe to ship, red means a real problem. A flaky or slow pipeline trains people
to ignore it — which defeats its purpose.

## When to Use

- Setting up or restructuring CI/CD for a project
- Adding a quality gate (lint, types, tests, security scan, build)
- Configuring or hardening a deployment
- The pipeline is slow, flaky, or people are bypassing it

## Process

1. **Gate the essentials on every change:** build, lint/format, type-check, tests, and a basic
   security/dependency scan. Failures must block merge.
2. **Make it deterministic.** Pin tool and dependency versions; control the environment. The same
   commit must produce the same result every run.
3. **Kill flakiness at the source.** A test that passes "usually" is broken; fix or quarantine it, don't
   add blanket retries that mask real failures.
4. **Keep it fast.** Cache dependencies and build artifacts, parallelize independent jobs, run the
   cheap fast checks first to fail early.
5. **Fail loudly and legibly.** Errors should say what broke and where; surface logs and artifacts.
6. **Automate deploys with a safety net:** repeatable releases, health checks, and an easy rollback
   ([[launch-readiness]]). Protect secrets via the platform, never in the repo.
7. **Treat pipeline config as code** — reviewed, versioned, and tested like everything else.

## Common Rationalizations

- "I'll just rerun it until it's green." — Retrying a flaky pipeline normalizes ignoring real failures.
- "Tests can run after merge." — Then main breaks and everyone is blocked; gate before merge.
- "It's slow but it works." — A slow pipeline gets skipped or worked around, eroding the gate.
- "Deploy by hand this once." — Manual deploys aren't repeatable and fail at the worst time.

## Red Flags

- Required checks that don't actually block merge
- Blanket auto-retries hiding flaky tests
- Builds that depend on unpinned versions or machine state
- A pipeline so slow people push around it
- Secrets in pipeline files; manual, unscripted deploys
- Red builds on main treated as normal

## Verification

- [ ] Build, lint, types, tests, and a security scan run and block on failure
- [ ] Runs are deterministic (pinned versions, controlled env)
- [ ] No flaky tests masked by retries
- [ ] Pipeline is fast (caching, parallelism, fast checks first)
- [ ] Deploys are automated with health checks and rollback; secrets are managed
- [ ] Pipeline config is reviewed and versioned
