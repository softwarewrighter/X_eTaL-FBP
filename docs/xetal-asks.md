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
| X1 | open (planned upstream: X_eTaL Saga 29, algebraic data) | feature | Records and sum types: an information packet is a typed record (id, kind, payload, owner), and its kind a closed set of variants (data, open bracket, close bracket, control); a component's effects and results are a closed set of typed outcomes (the research, pp. 10, 23). Today a tuple has no names (TU3) and there are no sums, so packets are columns of an Int table and kinds are Int codes | Packets, Scheduler (planned) | Int codes for kinds and a packet table indexed by IP id; payloads are numbers |
