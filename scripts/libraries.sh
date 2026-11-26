#!/usr/bin/env bash
# Get X_eTaL-libraries at the known-good commit in LIBRARIES_COMMIT: a
# clone in work/libraries (gitignored), never a tracked copy, as
# scripts/xetal.sh gets X_eTaL. Its libs/*/src go on XETAL_PATH after
# this repository's own (scripts/xt). Safe to run again. Progress goes
# to stderr; the last line (stdout) is the checked-out commit.
#   scripts/libraries.sh
#   LIBRARIES_SOURCE=../X_eTaL-libraries scripts/libraries.sh   # clone from a local checkout
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
commit="$(tr -d '[:space:]' < "$root/LIBRARIES_COMMIT")"
source="${LIBRARIES_SOURCE:-https://github.com/softwarewrighter/X_eTaL-libraries.git}"
clone="$root/work/libraries"

if [ ! -d "$clone/.git" ]; then
    mkdir -p "$root/work"
    git clone --quiet "$source" "$clone" >&2
fi
if ! git -C "$clone" cat-file -e "$commit^{commit}" 2>/dev/null; then
    git -C "$clone" fetch --quiet origin >&2
fi
git -C "$clone" checkout --quiet --detach "$commit"
git -C "$clone" rev-parse --short HEAD
