#!/usr/bin/env bash
# Run a library's test programs (or its demos with --demos), or one of
# them, with the known-good xetal and every library on XETAL_PATH, from
# the program's own directory, as the baselines run them.
#   scripts/run-lib.sh Connections            # every tests/*.xtl
#   scripts/run-lib.sh --demos Connections    # every demos/*.xtl
#   scripts/run-lib.sh --demos Connections backpressure
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dir=tests
[ "${1:-}" = --demos ] && { dir=demos; shift; }
name="${1:?usage: run-lib.sh [--demos] Name [program]}"
d="$root/libs/$name/$dir"
[ -d "$d" ] || { echo "run-lib: no libs/$name/$dir" >&2; exit 1; }
cd "$d"
if [ -n "${2:-}" ]; then progs=("${2%.xtl}.xtl"); else progs=(*.xtl); fi
for p in "${progs[@]}"; do
  [ ${#progs[@]} -gt 1 ] && echo "== $name/$dir/$p"
  "$root/scripts/xt" run "$p"
done
