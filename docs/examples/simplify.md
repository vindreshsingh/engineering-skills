# Before / After: `simplify`

**Task:** "Read a few settings from environment variables with defaults."

## Without the skill (over-engineered)

Reaching for flexibility nobody asked for:

```ts
class ConfigValueResolver<T> {
  constructor(private readonly strategies: ResolutionStrategy<T>[]) {}
  resolve(key: string, fallback: T): T {
    for (const s of this.strategies) {
      const v = s.tryResolve(key);
      if (v !== undefined) return v;
    }
    return fallback;
  }
}
const resolver = new ConfigValueResolver([
  new EnvVarStrategy(),
  new DefaultStrategy(),
]);
export const PORT = resolver.resolve("PORT", 3000);
export const HOST = resolver.resolve("HOST", "localhost");
```

Three classes, an interface, and a strategy list — to read `process.env`. There is exactly one resolution
"strategy" that will ever exist. The abstraction hides what the code does and is harder to read than the
problem deserves.

## With the skill (`simplify`)

Behavior-preserving: delete the indirection, keep the result identical.

```ts
function env(key: string, fallback: string): string {
  return process.env[key] ?? fallback;
}
export const PORT = Number(env("PORT", "3000"));
export const HOST = env("HOST", "localhost");
```

## Why it's better

Same behavior, a fraction of the surface. `simplify` removes **accidental** complexity — the speculative
"strategy" framework built for a second source that doesn't exist — and leaves the **essential** logic in
a form a stranger can read in one pass. The rule it applies: the simplest code that correctly solves the
*actual* problem, not the most flexible one. (If a real second source appears later, add it *then* — YAGNI
beats premature abstraction.)
