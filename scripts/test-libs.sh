#!/usr/bin/env bash
# Test this repository's libraries (every libs/<Name>/, or the named
# ones) with reg-rs, as X_eTaL-libraries does: each library's tests/ is
# its reg-rs data directory (REG_RS_DATA_DIR), and its baselines run
# from there:
#   - types.rgt: scripts/xt type ../src/<Name>.xtl (the exports' types);
#   - NAME.rgt for each tests/NAME.xtl: scripts/xt run NAME.xtl;
#   - demo-D.rgt for each demos/D.xtl: scripts/xt run ../demos/D.xtl;
#   - expand-NAME.rgt for each program that calls a library's macro.
# A baseline missing, or left over from a program that is gone, fails;
# so does any FAIL line (a failed Check) in a baseline's output, unless
# the program says "# shows failures". XETAL_BLESS=1 creates missing
# baselines and rebases the rest (review the diff!).
#   scripts/test-libs.sh [Name...]
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
command -v reg-rs >/dev/null || { echo "test-libs: reg-rs not found on PATH" >&2; exit 127; }
"$root/scripts/xetal.sh" >/dev/null 2>&1 || { "$root/scripts/xetal.sh"; exit 1; }
[ -d "$root/work/libraries/libs" ] || "$root/scripts/libraries.sh" >/dev/null
bless="${XETAL_BLESS:-}"
if [ $# -gt 0 ]; then names=("$@"); else
  names=(); for d in "$root"/libs/*/; do [ -d "$d/src" ] && names+=("$(basename "$d")"); done
fi
xt="$root/scripts/xt"
fail=0; n=0
for name in ${names[@]+"${names[@]}"}; do
  d="$root/libs/$name"
  [ -d "$d/src" ] || { echo "test: no library libs/$name" >&2; exit 1; }
  n=$((n + 1))
  src="$name.xtl"; [ -f "$d/src/$src" ] || src="$name.xtlm"
  wanted=("types|$xt type ../src/$src|")
  macro='[a-z][a-z0-9]*:[a-z]_[A-Za-z0-9]*<'
  for p in "$d"/tests/*.xtl; do
    [ -e "$p" ] || continue; b="$(basename "$p" .xtl)"
    wanted+=("$b|$xt run $b.xtl|$p")
    grep -qE "$macro" "$p" && wanted+=("expand-$b|$xt expand $b.xtl|$p")
  done
  for p in "$d"/demos/*.xtl; do
    [ -e "$p" ] || continue; b="$(basename "$p" .xtl)"
    wanted+=("demo-$b|$xt run ../demos/$b.xtl|$p")
    grep -qE "$macro" "$p" && wanted+=("expand-demo-$b|$xt expand ../demos/$b.xtl|$p")
  done
  export REG_RS_DATA_DIR="$d/tests"
  cd "$d/tests"
  rel="../../../scripts/xt"
  for w in "${wanted[@]}"; do
    IFS='|' read -r t cmd prog <<<"$w"
    cmd="${cmd//$xt/$rel}"
    if [ ! -f "$t.rgt" ]; then
      if [ "$bless" = 1 ]; then rm -f "$t".tdb*; reg-rs create -t "$t" -c "$cmd" >/dev/null; echo "created: $name/$t"
      else echo "FAIL: $name/$t: no baseline $t.rgt (XETAL_BLESS=1 to create)"; fail=1; continue; fi
    elif ! grep -qF "command = \"$cmd\"" "$t.rgt"; then
      echo "FAIL: $name/$t: $t.rgt does not run '$cmd'"; fail=1
    fi
  done
  for r in *.rgt; do
    [ -e "$r" ] || continue
    t="${r%.rgt}"
    printf '%s\n' "${wanted[@]}" | grep "^$t|" >/dev/null || { echo "FAIL: $name/$t: $r has no program (remove it)"; fail=1; }
  done
  if [ "$bless" = 1 ]; then
    reg-rs run -q -p .rgt >/dev/null 2>&1 || true
    reg-rs rebase -p .rgt >/dev/null 2>&1
    echo "blessed: $name"
  elif reg-rs run -q -p .rgt >/dev/null 2>&1; then
    echo "ok: $name ($(ls *.rgt | wc -l | tr -d ' ') baselines)"
  else
    echo "FAIL: $name"; reg-rs run -vv -p .rgt || true; fail=1
  fi
  for w in "${wanted[@]}"; do
    IFS='|' read -r t cmd prog <<<"$w"
    [ -f "$t.out" ] && grep -q '^FAIL' "$t.out" || continue
    [ -n "$prog" ] && grep -q '# shows failures' "$prog" && continue
    echo "FAIL: $name/$t: a check failed:"; grep '^FAIL' "$t.out"; fail=1
  done
  cd "$root"
done
echo "test-libs: $n librar$([ $n = 1 ] && echo y || echo ies)$([ $fail = 0 ] && echo ', all passed' || echo ', FAILURES')"
exit $fail
