---
name: i18n-l10n
description: Internationalizes and localizes products — strings, locales, formats, RTL, and translation workflow. Use when adding languages, fixing locale bugs, or expanding to non-English markets.
---

# i18n / l10n

English-only caps your market. **i18n** (internationalization) makes the app locale-ready; **l10n**
(localization) delivers each language correctly — including dates, numbers, currency, and layout direction.

Pairs with [[ui-craft]] for UI implementation, [[accessibility]] for RTL and language attributes,
[[technical-writing]] for translated docs, and [[test-first]] for locale-specific tests.

## When to Use

- Adding a second language
- Hard-coded strings in UI or API errors
- Date/number/currency shown wrong in non-US locales
- RTL language support (Arabic, Hebrew)
- Translation workflow for releases

Skip for internal English-only tools with documented scope.

## Process

### 1. Choose i18n architecture

| Approach | Best for |
|----------|----------|
| Key-based JSON/PO files | Web (react-i18next, next-intl) |
| Platform native (Android strings.xml, iOS Localizable.strings) | Mobile |
| DB-backed strings | CMS-heavy, frequent copy changes |

Rule: **no user-facing string literals** in components after i18n pass.

### 2. Extract and namespace strings

```text
namespace.feature.element
auth.login.title
auth.login.submit
errors.network.timeout
```

- Complete sentences in one key — don't split for grammar across keys
- Interpolation for variables: `"Hello, {{name}}"`
- Pluralization keys per ICU/plural rules

### 3. Locale formatting

Centralize:

- Dates and times (timezone-aware)
- Numbers and decimals
- Currency (ISO 4217)
- Relative time ("2 hours ago")

Test with `de-DE`, `ja-JP`, `ar-SA` at minimum.

### 4. RTL and layout

- `dir="rtl"` on `<html>` or root when locale is RTL
- Mirror icons that imply direction (arrows, back)
- Don't mirror logos or media with text
- Test [[accessibility]] with screen reader in target language

### 5. Translation workflow

1. Export strings (JSON/XLIFF)
2. Translate — human for marketing copy, MT+review for UI chrome OK
3. Import and verify in UI (pseudo-locale for overflow: `[[!!]]`)
4. Lock strings before release; changelog for copy changes

### 6. Test per locale

- [ ] All screens render without truncation/overflow
- [ ] Plural forms correct (1 item vs 5 items)
- [ ] Error messages translated
- [ ] SEO: hreflang tags if public web ([[seo-growth]])

## Common Rationalizations

- **"We'll translate when we have users there"** — Retrofit i18n costs 3–5x vs building in.
- **"Google Translate in the UI"** — Quality breaks trust; use proper workflow.
- **"English URLs are fine"** — hreflang and locale paths matter for SEO.

## Red Flags

- Concatenated strings: `"Hello " + name`
- Dates hard-coded as MM/DD/YYYY
- Icons not mirrored in RTL
- Missing translations fall back to empty string
- Legal/compliance text machine-translated only

## Verification

- [ ] No hard-coded user-facing strings in changed files
- [ ] Keys namespaced; plurals and interpolation correct
- [ ] Formatting uses locale APIs
- [ ] RTL tested if applicable
- [ ] Translation export/import process documented
- [ ] At least one non-English locale verified in browser
