# Changes

Every commit, newest first, grouped by day. Times are Pacific, as
committed.

Categories: `feat` new capability, `fix` a bug or wrong behavior,
`refactor` structure without behavior change, `test` tests only,
`build` build and tooling, `lib` a library or a change to one, `docs`
documentation, `plan` saga planning and reordering, `chore`
agentrail bookkeeping (step complete, saga archive), `vendor` a move
of the pinned X_eTaL or X_eTaL-libraries.

## 2026-11-25

- 16:51 `build` Scaffold the repository after X_eTaL-libraries: CLAUDE.md (agentrail briefing plus this repository's policy; AGENTS.md links to it), README with copyright and license, this file, justfile and scripts (xetal pinned at 04c4c84 in XETAL_COMMIT, X_eTaL-libraries at c7e812e in LIBRARIES_COMMIT, both cloned into the ignored work/; scripts/xt puts libs/*/src then the pinned libraries on XETAL_PATH; reg-rs library tests, run, new-lib with templates/Library, the gate, American spelling check), .gitignore, pyproject.toml and uv.lock (stdlib only). docs/plan.md from docs/research.pdf, its text and its diagrams (dependency direction p. 64, bounded connection p. 40, backpressure p. 47, port-level network p. 52, phases p. 69, explorer p. 71): decisions F1-F12, acceptance tests, Saga 1 (foundations, 9 steps) and later sagas. docs/xetal-asks.md with X1 (records and sums). The agentrail saga fbp-foundations with its nine steps. The research PDF is kept as archival, not normative.

## 2026-11-24

- 09:47 `chore` Initial commit: an empty README.
