# Asks for X_eTaL

Features X_eTaL-FBP needs that X_eTaL (or X_eTaL-libraries) does not
have yet, and bugs found while building on them. This repository does
not change X_eTaL: each ask is filed here (and taken to `../X_eTaL`),
the library uses the workaround noted below or waits, and the
workaround is removed when the ask lands in the known-good commit
(`XETAL_COMMIT`, now 04c4c84; X_eTaL-libraries at `LIBRARIES_COMMIT`,
now c7e812e).

Each entry: status (open, filed, landed, dropped), kind (feature, bug
or speed), which library needs it, why, a minimal repro or example,
and the workaround in use.

| # | Status | Kind | Ask | Libraries | Workaround |
| - | ------ | ---- | --- | --------- | ---------- |
| X1 | open (planned upstream: X_eTaL Saga 29, algebraic data) | feature | Records and sum types: an information packet is a typed record (id, kind, payload, owner), and its kind a closed set of variants (data, open bracket, close bracket, control); a component's effects and results are a closed set of typed outcomes (the research, pp. 10, 23). Today a tuple has no names (TU3) and there are no sums, so packets are columns of an Int table and kinds are Int codes | Packets, Scheduler (planned); repro `audit/a5-records.xtl` (docs/audit.md A5) | Int codes for kinds and a packet table indexed by IP id; payloads are numbers |
| X2 | open (decided upstream 2026-11-24 as B22 and B23, steps 204-205; not in the pin 04c4c84) | feature | `w_ithout` (APL2's without) and `e_nlist` (APL2's enlist, the raze of a box of boxes): `ids w_ithout back` is `error[unknown-builtin]` at the pin, as is `e_nlist` | Packets (`ip:a_udit` razes the connections' contents; the lifecycle demo removes the IPs given back) | `(n_ot ids m_ember? back) r_eplicate ids`; a raze by reduce, `d_isclose '{ e_nclose (d_isclose _l) c_at d_isclose _r } r_/ b` (as X_eTaL-libraries' Graphs does); remove both when the pin moves past them |
| X3 | open | bug | A guard ending in an error (`[]S_IGNAL`) makes a tuple part that only passes through infer as `Never`: `u:f_ := { (a, b) -> a < 0 ? "x" []S_IGNAL "y"; (a, b) }` is `Num a => (a, Never) -> (a, Never)`, where without the guard it is `(a, b) -> (a, b)`. Programs still type-check and run, but `xetal type` shows (and the libraries pin) wrong types; repro `audit/a10-never-passthrough.xtl` | Networks (`nw:p_rocess`, `nw:c_onnect`: the connections matrix and the optional column show `Never`) | none needed to run; the types are pinned as they are and the page says so; rebase types.rgt when it is fixed |
