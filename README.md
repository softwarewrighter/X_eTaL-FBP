# X_eTaL-FBP

Flow-Based Programming for [X_eTaL](https://github.com/softwarewrighter/X_eTaL),
the eXperimental Extensible Typed Array Language: J. Paul Morrison's
classical FBP written in X_eTaL itself. An application is a network
of independently running processes that pass information packets
(IPs) through bounded connections between named ports; the network is
defined apart from the components it connects, so a component never
names its neighbors, and a full connection holds its producer back
(backpressure).

```
  +-----------+  OUT          bounded connection          IN  +-----------+
  | Process A |---o-->[ 3 | 2 | 1 |   |   ]--(3 of 5)------o-->| Process B |
  | producer  |  ERR                                       CTRL | consumer  |
  +-----------+---o-->[ x |   |   ]------------------------o-->+-----------+
```

The networks run in a deterministic simulator first: every run is
repeatable, so a run is a test and its trace can be replayed.

## Status

Early. The repository is set up; the first libraries (bounded
connections, packets, networks, the scheduler, standard components)
follow in order. [`docs/plan.md`](docs/plan.md) has the architecture
decisions and the roadmap, [`docs/xetal-asks.md`](docs/xetal-asks.md)
what this repository needs from X_eTaL.

## How this fits

| Repository | What |
| ---------- | ---- |
| [X_eTaL](https://github.com/softwarewrighter/X_eTaL) | the language: core, macros, types |
| [X_eTaL-libraries](https://github.com/softwarewrighter/X_eTaL-libraries) | reusable X_eTaL libraries (this repository uses its Check and Graphs) |
| **X_eTaL-FBP** | **flow-based programming: components, ports, connections, networks, scheduling, simulation** |
| X_eTaL-microservices (planned) | services, deployment and operations, built on the networks here |

Dependencies point one way: X_eTaL-microservices may depend on
X_eTaL-FBP, never the other way, and X_eTaL-FBP depends only on
X_eTaL and X_eTaL-libraries.

## Layout

| Path | What |
| ---- | ---- |
| `libs/<Name>/` | one library each: `src/` (the `.xtl`, and a `.xtlm` where a macro earns its place), `tests/` (reg-rs baselines), `docs/README.md` (its reference), `demos/` |
| `docs/` | the plan, the asks for X_eTaL, the archival research (`research.pdf`) |
| `scripts/` | the tasks behind `just` |
| `templates/Library/` | the skeleton `just new-lib` copies |

## Build and test

X_eTaL and X_eTaL-libraries are used at known-good commits
(`XETAL_COMMIT`, `LIBRARIES_COMMIT`): `just xetal` clones X_eTaL into
`work/xetal` and builds `bin/xetal`, `just libraries` clones
X_eTaL-libraries into `work/libraries`. Neither copy is tracked.

```bash
just                 # list the tasks
just xetal           # get and build xetal at XETAL_COMMIT
just eval "'+ r_/ r_ange 10"
just test            # every library's reg-rs baselines
just gate            # the pre-commit gate: tests, spelling, markdown
```

Needs: Rust (cargo), [just](https://github.com/casey/just),
[uv](https://github.com/astral-sh/uv), reg-rs and
sw-markdown-checker.

## Copyright

Copyright (c) 2026 Michael A Wright

## License

MIT. See [`LICENSE`](LICENSE) and [`COPYRIGHT`](COPYRIGHT).
