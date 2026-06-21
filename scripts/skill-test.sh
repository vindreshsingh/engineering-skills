#!/usr/bin/env bash
# skill-test.sh — structural runner for behavioral skill tests.
# Validates that each tests/<skill>.test.md is well-formed, maps to a real skill,
# and that the skill it tests has a Common Rationalizations section to address the
# scenario's rationalizations. Also reports coverage (skills without a test).
#
#   bash scripts/skill-test.sh             # validate + coverage
#   bash scripts/skill-test.sh --coverage  # coverage report only
#
# The full behavioral run (dispatching an agent against each scenario) is driven by
# a human/orchestrator per docs/testing-skills.md; this enforces the structure.

set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

errors=0
fail() { printf '  ✗ %s\n' "$1"; errors=$((errors + 1)); }

required=("## Scenario" "## Without the skill" "## With the skill" "## Rationalizations to resist" "## Pass criteria")

# Map of skill-name -> SKILL.md path (skills may be nested, e.g. skills/marketing/x)
declare -a skill_names=()
while IFS= read -r skillmd; do
  d="$(dirname "$skillmd")"
  skill_names+=("$(basename "$d")")
done < <(find skills -name SKILL.md | sort)

skill_has_dir() { # $1 = name
  for n in "${skill_names[@]}"; do [ "$n" = "$1" ] && return 0; done
  return 1
}
skill_path() { find skills -type d -name "$1" -print -quit; }

mode="${1:-validate}"

if [ "$mode" != "--coverage" ]; then
  echo "Validating skill tests..."
  shopt -s nullglob
  for t in tests/*.test.md; do
    base="$(basename "$t" .test.md)"
    [ "$base" = "template" ] && continue

    for section in "${required[@]}"; do
      grep -qF "$section" "$t" || fail "$base: test missing section '$section'"
    done

    if skill_has_dir "$base"; then
      sp="$(skill_path "$base")"
      grep -qE "^##[[:space:]]+Common Rationalizations" "$sp/SKILL.md" \
        || fail "$base: skill has no 'Common Rationalizations' to address the test's rationalizations"
    else
      fail "$base: no matching skill (skills/**/$base/SKILL.md not found)"
    fi
  done
  shopt -u nullglob
fi

# Coverage
echo
echo "Coverage:"
total=${#skill_names[@]}
tested=0
missing=()
for n in "${skill_names[@]}"; do
  if [ -f "tests/${n}.test.md" ]; then tested=$((tested + 1)); else missing+=("$n"); fi
done
pct=0; [ "$total" -gt 0 ] && pct=$(( tested * 100 / total ))
echo "  $tested / $total skills have a behavioral test (${pct}%)"
if [ "${#missing[@]}" -gt 0 ] && [ "$mode" = "--coverage" ]; then
  echo "  Missing tests for:"
  printf '    - %s\n' "${missing[@]}"
fi

echo
if [ "$errors" -eq 0 ]; then
  echo "✓ Skill tests well-formed."
  exit 0
else
  echo "✗ $errors problem(s) found."
  exit 1
fi
