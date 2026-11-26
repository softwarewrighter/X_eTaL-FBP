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

- 20:48 `docs` Capability audit (step 2): docs/audit.md, what the known-good X_eTaL (04c4c84) and X_eTaL-libraries (c7e812e) can do for FBP, each finding a probe in audit/ pinned by reg-rs (scripts/test-audit.sh, now in the gate): tuple state through p_ower and recursion (A1), a vector of boxed step functions applied without dispatch (A2), a million-deep self-call (A3), FIFOs and ring buffers by c_at, d_rop, a_mend and m_od (A4; m_od is maths order), records refused as `record-field` (A5, ask X1's repro), traces pure or by a ! variable (A6), Graphs and Check at the pin (A7), a .xtlm macro parsing `a.OUT -> b.IN [4]` with a located refusal (A8), Plot bars and charts and []G_RID (A9); about 10 microseconds per tick. Nothing blocks Saga 1.
- 18:39 `chore` Complete step 1 (setup).
- 16:51 `build` Scaffold the repository after X_eTaL-libraries: CLAUDE.md (agentrail briefing plus this repository's policy; AGENTS.md links to it), README with copyright and license, this file, justfile and scripts (xetal pinned at 04c4c84 in XETAL_COMMIT, X_eTaL-libraries at c7e812e in LIBRARIES_COMMIT, both cloned into the ignored work/; scripts/xt puts libs/*/src then the pinned libraries on XETAL_PATH; reg-rs library tests, run, new-lib with templates/Library, the gate, American spelling check), .gitignore, pyproject.toml and uv.lock (stdlib only). docs/plan.md from docs/research.pdf, its text and its diagrams (dependency direction p. 64, bounded connection p. 40, backpressure p. 47, port-level network p. 52, phases p. 69, explorer p. 71): decisions F1-F12, acceptance tests, Saga 1 (foundations, 9 steps) and later sagas. docs/xetal-asks.md with X1 (records and sums). The agentrail saga fbp-foundations with its nine steps. The research PDF is kept as archival, not normative.

## 2026-11-24

- 09:47 `chore` Initial commit: an empty README.
