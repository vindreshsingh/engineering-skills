---
name: source-first
description: Grounds work in the actual source — code, types, docs, and data — before reasoning or writing. Use whenever you're about to rely on how something behaves, an API's shape, or a library's contract.
---

# Source First

Check the source before you trust your memory of it. APIs change, your recollection is fuzzy, and a
library's real behavior lives in its code and types — not in what you assume it does.

## When to Use

- Calling an API, library, or internal module you're not 100% certain about
- Reasoning about how existing code behaves before changing it
- A version may differ from what you remember
- Debugging behavior that "should" work according to your mental model

## Process

1. **Find the authoritative source** — the function definition, the type signature, the official
   docs for the installed version, the actual data sample.
2. **Read the relevant part**, not a search-result snippet. Signatures, defaults, error cases, and
   side effects are where assumptions go wrong.
3. **Confirm the version.** Behavior and APIs differ across releases; check what's actually installed.
4. **Trace the real path** for existing code: follow the calls rather than guessing the flow.
5. **Then write**, citing what you verified. If a claim matters, it should be backed by something you
   actually looked at.
6. **When the source contradicts your assumption, the source wins** — update the plan.

This pairs with [[context-curation]]: load the real source into context instead of a paraphrase.

## Common Rationalizations

- "I know this API." — You know a version of it; confirm the one that's installed.
- "The docs are probably right." — Docs lag code; for behavior that matters, read the code.
- "I'll assume the default." — Defaults change and surprise; verify the one in play.
- "Tracing the flow takes too long." — Less long than debugging a fix built on a wrong assumption.

## Red Flags

- Writing against an API from memory without checking the signature
- "It should work like X" with no source consulted
- Ignoring which version is installed
- A bug fix based on an assumed code path rather than the traced one
- Copy-pasting a snippet whose behavior you haven't verified for your version

## Verification

- [ ] Key APIs/contracts were confirmed against the real signature or docs
- [ ] The installed version was checked where behavior depends on it
- [ ] Existing behavior was traced in the code, not assumed
- [ ] Claims that matter are backed by something actually read
- [ ] Where source contradicted assumptions, the work was corrected
