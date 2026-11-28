# Changes

Every commit, newest first, grouped by day. Times are Pacific, as
committed.

Categories: `feat` new capability, `fix` a bug or wrong behavior,
`refactor` structure without behavior change, `test` tests only,
`build` build and tooling, `lib` a library or a change to one, `docs`
documentation, `plan` saga planning and reordering, `chore`
agentrail bookkeeping (step complete, saga archive), `vendor` a move
of the pinned X_eTaL or X_eTaL-libraries.

## 2026-11-27

- 10:58 `lib` Networks (step 5): networks as data, `(names, ports, connections)`; `nw:p_rocess` with ports from words (`"IN CTRL?"`, `?` optional) and `nw:c_onnect` from `process.PORT` to `process.PORT`, refusing duplicate names, bad names and endpoints, unknown processes and ports, wrong directions, bad capacities and policies, and a second connection from one output (inputs may merge); readers and `nw:l_isting`; `nw:p_roblems` (unconnected required ports, isolated processes); analysis through X_eTaL-libraries' Graphs: adjacency, feedback loops, acyclic?, sources, sinks, reachability. The research's p. 52 order-processing network is a test (accepted, not a DAG, all but audit on a loop) and a demo. Ask X3 (a bug): a guard ending in `[]S_IGNAL` makes a pass-through tuple part infer as `Never`; probe A10 pins it (scripts/test-audit.sh runs `xetal type` for type probes).
- 17:18 `chore` Complete step 4 (packets).
- 17:18 `lib` Packets (step 4): information packets with identity, a table `(kinds, payloads, owners, born)`; `ip:c_reate` (by a process only), `ip:m_ove` and `ip:d_iscard` with ownership checked (no-packet, dropped-packet, not-owner refusals), readers per column, `ip:o_wnedBy`, `ip:a_live`, `ip:d_escribe`; `ip:a_udit` checks the table against the connections' contents (an IP in two places, queued but not owned, lost); bracket IPs (`ip:Open`, `ip:Close`) with `ip:d_epths`, `ip:b_alanced?`, `ip:g_roups`. Demo: five IPs through a Connections connection, audited at each stage. Ask X2: `w_ithout` and `e_nlist`, decided upstream, not in the pin (workarounds named). Plan: payloads are Floats until X1.

## 2026-11-26

- 10:06 `chore` Complete step 3 (connections).
- 10:05 `lib` Connections (step 3): bounded FIFO connections as values, `(capacity, policy, contents, counts)`; `cn:n_ew` (bad-capacity, bad-policy refusals), `cn:s_end`, `cn:r_eceive`, occupancy, room, utilization, `cn:d_escribe` ("3 of 5 slots occupied"), and the four overflow policies (Block, DropOldest, DropNewest, Reject) with counts admitted, blocked, rejected, dropped, delivered. `cn:r_un` runs a producer and a consumer at fixed rates per second; the research's p. 47 experiment is a test (occupancy 4 8 12 16 16 ..., 32 offered IPs not admitted at capacity 16, 16 at capacity 32). Demos: backpressure (table, bars, chart) and the four policies side by side. README: the library table and how another repository pins and imports these libraries; plan: when X_eTaL-microservices can build on them, the time model decided.

## 2026-11-25

- 20:48 `chore` Complete step 2 (capability-audit).
- 20:48 `docs` Capability audit (step 2): docs/audit.md, what the known-good X_eTaL (04c4c84) and X_eTaL-libraries (c7e812e) can do for FBP, each finding a probe in audit/ pinned by reg-rs (scripts/test-audit.sh, now in the gate): tuple state through p_ower and recursion (A1), a vector of boxed step functions applied without dispatch (A2), a million-deep self-call (A3), FIFOs and ring buffers by c_at, d_rop, a_mend and m_od (A4; m_od is maths order), records refused as `record-field` (A5, ask X1's repro), traces pure or by a ! variable (A6), Graphs and Check at the pin (A7), a .xtlm macro parsing `a.OUT -> b.IN [4]` with a located refusal (A8), Plot bars and charts and []G_RID (A9); about 10 microseconds per tick. Nothing blocks Saga 1.
- 18:39 `chore` Complete step 1 (setup).
- 16:51 `build` Scaffold the repository after X_eTaL-libraries: CLAUDE.md (agentrail briefing plus this repository's policy; AGENTS.md links to it), README with copyright and license, this file, justfile and scripts (xetal pinned at 04c4c84 in XETAL_COMMIT, X_eTaL-libraries at c7e812e in LIBRARIES_COMMIT, both cloned into the ignored work/; scripts/xt puts libs/*/src then the pinned libraries on XETAL_PATH; reg-rs library tests, run, new-lib with templates/Library, the gate, American spelling check), .gitignore, pyproject.toml and uv.lock (stdlib only). docs/plan.md from docs/research.pdf, its text and its diagrams (dependency direction p. 64, bounded connection p. 40, backpressure p. 47, port-level network p. 52, phases p. 69, explorer p. 71): decisions F1-F12, acceptance tests, Saga 1 (foundations, 9 steps) and later sagas. docs/xetal-asks.md with X1 (records and sums). The agentrail saga fbp-foundations with its nine steps. The research PDF is kept as archival, not normative.

## 2026-11-24

- 09:47 `chore` Initial commit: an empty README.
