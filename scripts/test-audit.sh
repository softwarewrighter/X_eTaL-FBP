#!/usr/bin/env bash
# The capability audit's probes (audit/*.xtl, docs/audit.md) pinned
# with reg-rs, audit/ being their REG_RS_DATA_DIR: each NAME.xtl has
# NAME.rgt running "scripts/xt run NAME.xtl" (a probe that shows a
# refusal pins its error and exit status), and a probe that calls a
# macro also pins "scripts/xt expand" as expand-NAME.rgt. When the pin
# moves, a changed baseline is a changed capability: update
# docs/audit.md and docs/xetal-asks.md with it. XETAL_BLESS=1 creates
# missing baselines and rebases the rest (review the diff!).
#   scripts/test-audit.sh
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
command -v reg-rs >/dev/null || { echo "test-audit: reg-rs not found on PATH" >&2; exit 127; }
export REG_RS_DATA_DIR="$root/audit"
cd "$root/audit"
fail=0; wanted=()
for p in *.xtl; do
  b="${p%.xtl}"
  wanted+=("$b|../scripts/xt run $p")
  grep -qE '[a-z][a-z0-9]*:[a-z]_[A-Za-z0-9]*<' "$p" && wanted+=("expand-$b|../scripts/xt expand $p")
done
for w in "${wanted[@]}"; do
  IFS='|' read -r t cmd <<<"$w"
  if [ ! -f "$t.rgt" ]; then
    if [ "${XETAL_BLESS:-}" = 1 ]; then rm -f "$t".tdb*; reg-rs create -t "$t" -c "$cmd" >/dev/null; echo "created: audit/$t"
    else echo "FAIL: audit/$t: no baseline (XETAL_BLESS=1 to create)"; fail=1; fi
  fi
done
for r in *.rgt; do
  printf '%s\n' "${wanted[@]}" | grep -q "^${r%.rgt}|" || { echo "FAIL: audit/$r has no probe (remove it)"; fail=1; }
done
if [ "${XETAL_BLESS:-}" = 1 ]; then
  reg-rs run -q -p .rgt >/dev/null 2>&1 || true; reg-rs rebase -p .rgt >/dev/null 2>&1; echo "blessed: audit"
elif reg-rs run -q -p .rgt >/dev/null 2>&1; then echo "ok: audit ($(ls *.rgt | wc -l | tr -d ' ') baselines)"
else echo "FAIL: audit"; reg-rs run -vv -p .rgt || true; fail=1; fi
exit $fail
