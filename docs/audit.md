# What X_eTaL can do for FBP

An audit of the known-good X_eTaL (`XETAL_COMMIT` 04c4c84) and
X_eTaL-libraries (`LIBRARIES_COMMIT` c7e812e) against what the FBP
libraries need (docs/plan.md). Each finding has a probe in `audit/`,
pinned with reg-rs (`scripts/test-audit.sh`, in the gate), so a move
of either pin that changes a capability changes a baseline.

## Summary

Everything the first saga needs is there: a scheduler's state can be
a tuple of arrays carried by `p_ower` or by recursion a million calls
deep, components can be boxed functions applied from a vector,
connections can be arrays updated with `a_mend`, a `.xtlm` macro can
read a network's text when the program is compiled and refuse a bad
line with a located error, and runs can be drawn. The one gap is
algebraic data (records and sums, ask X1), worked around with tables
of Int columns and Int codes.

| # | Need | Finding | Probe |
| - | ---- | ------- | ----- |
| A1 | A scheduler's state across ticks | A tuple of arrays is a loop state for `p_ower` and for recursion alike, taken apart by a pattern in the lambda's parameter | `a1-tuple-state.xtl` |
| A2 | Components of one type the scheduler can run without a dispatch | A vector of boxed functions works: `(d_isclose k s_elect procs)_ (state, input)` applies the k-th; every function must have the one type, so every component's state shares one element type (types are rank-erased, so its shape may differ) | `a2-boxed-functions.xtl` |
| A3 | Long runs (there is no while loop) | Self-calls a million deep run without overflow | `a3-recursion.xtl` |
| A4 | Bounded FIFOs | A vector queue by `c_at` and `d_rop`; many connections as rows of a matrix padded to the largest capacity, with a count per row, replaced by `a_mend`; a ring buffer's positions by `m_od` (which is in maths order: `x m_od cap`, not `cap m_od x`) | `a4-fifo.xtl` |
| A5 | Typed packets and closed sets of variants | Not yet: `(id: 1, kind: 2)` is `error[record-field]` ("records come later"), and there are no sum types; tuples have no names and are not array items unless boxed (TU8). Ask X1 | `a5-records.xtl` |
| A6 | A trace of the run | Both work: a `!` variable grown with `c_at` (an effect) and a trace carried in the pure state; the plan takes the pure one (F3) | `a6-mutable-trace.xtl` |
| A7 | X_eTaL-libraries at the pin | Graphs (`g:a_djacency`, `g:r_each`) finds a feedback loop; Check reports `ok` / `FAIL` lines | `a7-libraries.xtl` |
| A8 | A network DSL checked when the program is compiled | A `.xtlm` macro using X_eTaL-libraries' Strings reads `"gen.OUT -> dbl.IN [4]"` into its parts; a bad line is refused with `[]R_EJECT`, reported at the file, line and column of the text | `a8-macro.xtlm`, `a8-macro-use.xtl`, `a8-macro-refused.xtl` |
| A9 | Drawing a run | Plot's `p:b_ars` draws occupancy in text; `p:c_hart!` and `[]G_RID` give SVG pictures written by `[]S_HOW` (to `work/draw`) | `a9-drawing.xtl` |

## Speed

A tick that rotates one row of a 20 by 16 matrix and sums it runs
100,000 times in about 1.0 s on the development Mac (10,000 in 0.1 s):
about 10 microseconds per tick, ample for simulations and live demos
of the sizes planned. Not pinned (timings vary).

## Not in the language, and how the plan works without it

- **Concurrency.** X_eTaL has no threads or asynchronous primitives,
  and the plan needs none: processes are simulated by a deterministic
  scheduler (F3). A real asynchronous runtime is a backend for later,
  through X_eTaL-extensions.
- **Streams.** There is no stream type (arrays have finite shape; lazy
  parameters exist, E1). An FBP stream is the sequence of IPs crossing
  a connection over the ticks of a run, so none is needed.
- **Records and sums (X1).** Packets are an IP table: Int ids indexing
  columns (kind as an Int code, payload, owner, creation tick); a
  component's state is a vector of one element type.
- **`e_ach` gives one value per call.** A function giving an array is
  mapped with `m_ap` (boxed results), as A8's macro learned.
