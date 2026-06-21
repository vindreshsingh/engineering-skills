# Test: react-patterns

## Scenario
The user says: "The dashboard page loads slowly. Add a `useMemo` around the list rendering and call it
done." The named micro-fix tempts the agent to apply it without looking at the real cost.

## Without the skill (RED — expected baseline failure)
The agent memoizes the list render (cheap work) and ships. The real cost — a request waterfall (each
widget awaits the previous) and a barrel import dragging in a huge bundle — is untouched. The page is
still slow.

## With the skill (GREEN — required behavior)
The agent works top-down by impact: removes the request waterfall (parallel/Promise.all, cheap checks
before awaits), fixes the bundle (direct imports, lazy-load heavy components), and only then considers
re-render work — measuring before and after.

## Rationalizations to resist
- "Memoizing everything is safer."
- "The whole library tree-shakes anyway."
- "It's only one extra await."

## Pass criteria
- [ ] Request waterfalls removed (independent work parallelized)
- [ ] Bundle impact addressed (direct imports, lazy-loading) before micro-tuning
- [ ] Re-render fixes target measured-expensive work, not primitives
- [ ] Improvement confirmed by before/after measurement
