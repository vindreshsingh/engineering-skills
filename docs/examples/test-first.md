# Before / After: `test-first`

**Task:** "Add a function that applies a percentage discount to a cart total."

## Without the skill (rushed)

Write the code, eyeball it, ship.

```ts
export function applyDiscount(total: number, percent: number): number {
  return total - (total * percent) / 100;
}
```

Looks fine. It even works for the happy path (`applyDiscount(100, 10) === 90`). But nothing pins the
behavior, so the questions that matter were never asked:

- What if `percent` is `120`? → returns `-20`, a negative price.
- What if `percent` is negative? → silently *increases* the total.
- Floating point: `applyDiscount(0.1 + 0.2, ...)` rounding?
- Is the result rounded to cents, or is `33.333333` a valid price?

These surface as a production bug or a refund, not a failing test.

## With the skill (`test-first`)

Capture the intended behavior as failing tests **first**, which forces the edge-case decisions before
any code exists:

```ts
describe("applyDiscount", () => {
  it("applies a normal percentage", () => {
    expect(applyDiscount(100, 10)).toBe(90);
  });
  it("clamps percent to the 0–100 range", () => {
    expect(applyDiscount(100, 120)).toBe(0);   // never a negative price
    expect(applyDiscount(100, -5)).toBe(100);  // never an upcharge
  });
  it("rounds to whole cents", () => {
    expect(applyDiscount(99.99, 33)).toBe(66.99);
  });
});
```

Now the implementation is *defined by* those decisions:

```ts
export function applyDiscount(total: number, percent: number): number {
  const p = Math.min(100, Math.max(0, percent));     // clamp, decided up front
  const discounted = total - (total * p) / 100;
  return Math.round(discounted * 100) / 100;          // cents, decided up front
}
```

## Why it's better

The skill didn't make the agent smarter — it made it **decide the edge cases before writing code** and
leave behind a regression net. The negative-price and upcharge bugs are now impossible to reintroduce
silently, and the rounding rule is documented in an executable form. That's the difference between
"works on the demo" and "excellent code."
