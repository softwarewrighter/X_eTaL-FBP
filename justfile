# X_eTaL-FBP tasks. Recipes call scripts/*.sh, which hold the logic
# and work without just too. `just` alone lists the recipes.

set positional-arguments

# List the recipes
default:
    @just --list

# Get and build xetal at the known-good commit (XETAL_COMMIT): work/xetal, bin/xetal
xetal:
    scripts/xetal.sh

# Get X_eTaL-libraries at the known-good commit (LIBRARIES_COMMIT): work/libraries
libraries:
    scripts/libraries.sh

# The known-good X_eTaL and X_eTaL-libraries: the pins and the binary's version
versions: xetal
    @echo "X_eTaL           $(cat XETAL_COMMIT)"
    @echo "X_eTaL-libraries $(cat LIBRARIES_COMMIT)"
    @bin/xetal --version | head -1

# Evaluate an expression with the known-good xetal, every library on XETAL_PATH: just eval "'+ r_/ 1 2 3"
eval expr:
    @scripts/xt eval --ascii -e "$1"

# Start a library from templates/Library: just new-lib Connections cn: "bounded connections"
new-lib name alias summary:
    scripts/new-lib.sh "$1" "$2" "$3"

# Run a library's test programs (or one): just run Connections basics
run name prog="":
    @scripts/run-lib.sh "$1" ${2:+"$2"}

# Run a library's demos (or one): just demo Connections backpressure
demo name prog="":
    @scripts/run-lib.sh --demos "$1" ${2:+"$2"}

# The exported names and their types: just types Connections
types name:
    @scripts/xt type "libs/$1/src/$1.xtl"

# Test every library with reg-rs: pinned types, test programs, demos
test:
    scripts/test-libs.sh

# Test one library: just test-lib Connections
test-lib name:
    scripts/test-libs.sh "$1"

# Create missing baselines and accept new output for one library (review the diff!)
bless name:
    XETAL_BLESS=1 scripts/test-libs.sh "$1"

# American spellings only: every tracked file we own, British forms flagged
spelling:
    @scripts/check-spelling.py

# The full pre-commit gate
gate:
    scripts/gate.sh

# Show the agentrail saga state and the current step
status:
    agentrail status

# Open the saga plan
plan:
    @cat docs/plan.md
