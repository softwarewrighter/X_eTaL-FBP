#!/usr/bin/env bash
# The pre-commit gate: the known-good X_eTaL and X_eTaL-libraries,
# every library's tests (scripts/test-libs.sh, reg-rs), every macro
# library type-checked, American spellings, then ASCII-only markdown
# for the docs we own.
#   scripts/gate.sh
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
"$root/scripts/xetal.sh" >/dev/null 2>&1 || { "$root/scripts/xetal.sh"; exit 1; }
"$root/scripts/libraries.sh" >/dev/null
echo "ok: xetal $(cut -c1-7 XETAL_COMMIT), libraries $(cut -c1-7 LIBRARIES_COMMIT)"
"$root/scripts/test-libs.sh"
for m in libs/*/src/*.xtlm; do
  [ -e "$m" ] || continue
  "$root/scripts/xt" type "$m" >/dev/null || { "$root/scripts/xt" type "$m"; echo "FAIL: $m"; exit 1; }
done
echo "ok: macro libraries"
"$root/scripts/check-spelling.py" --self-test
"$root/scripts/check-spelling.py"
md=(README.md CHANGES.md)
for f in docs/*.md libs/*/README.md libs/*/docs/*.md; do [ -e "$f" ] && md+=("$f"); done
for f in "${md[@]}"; do sw-markdown-checker -f "$f" >/dev/null || { sw-markdown-checker -f "$f"; exit 1; }; done
echo "ok: markdown (${#md[@]} files)"
echo "gate: ok"
