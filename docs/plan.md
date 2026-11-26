# X_eTaL-FBP -- plan

Flow-Based Programming (J. Paul Morrison's classical FBP) in X_eTaL:
information packets, components and processes, named ports, bounded
connections with backpressure, networks defined apart from the
components they connect, and a deterministic scheduler that runs them,
all written in X_eTaL as libraries other repositories can import.

This document holds the architecture decisions, the roadmap (sagas and
steps) and the open questions. User-facing docs (README, library pages)
say what and how; saga and step talk lives only here.

Sources: `docs/research.pdf` (archival, NOT normative: the design
conversation that proposed this repository, text and diagrams), J. Paul
Morrison's *Flow-Based Programming* (1994; 2nd edition 2010), his FBP
web site and his 2005 paper *Patterns in Flow-Based Programming*.

## Where this repository sits

From the research's repository diagram (p. 64): dependencies point
down only.

```
X_eTaL-microservices   Richardson: services, deployment, operations
        |  (may depend on X_eTaL-FBP; never the other way)
X_eTaL-FBP             Morrison: networks, components, ports, streams, simulation
        |
X_eTaL-libraries       reusable algorithms (Check, Graphs, ...)
X_eTaL-extensions      Rust mechanisms (I/O, networking, async scheduling), later
        |
X_eTaL core            language, macros, types
```

FBP has uses well beyond microservices (the research, p. 66: ML and
GPU pipelines, audio synthesis, FPGA dataflow, embedded systems), so
nothing here may name a service, a deployment or a host. The
microservices repository adds service boundaries, transports and
operations on top of the networks defined here.

## Architecture decisions

| # | Decision |
| - | -------- |
| F1 | Classical FBP is the model (Morrison): independently executing processes, communicating only through information packets (IPs) sent over bounded connections between named ports; the network is defined outside the components, which never name their neighbors. |
| F2 | X_eTaL first. Everything is X_eTaL libraries (`libs/<Name>/`, laid out as X_eTaL-libraries lays its libraries out: `src/`, `tests/` with reg-rs baselines, `docs/README.md`, `demos/`, `README.md`), so a downstream repository puts `libs/*/src` on `XETAL_PATH`. Rust mechanisms (a real asynchronous runtime, sockets) belong in X_eTaL-extensions, generally reusable X_eTaL in X_eTaL-libraries; FBP-specific code, and code that X_eTaL-microservices will reuse, stays here. |
| F3 | Simulate first: the first scheduler is deterministic, in discrete ticks on a virtual clock, a pure function from a network state to the next (the research's "functional core"): every run is repeatable, testable by a golden and replayable. Effects (printing, drawing) happen only at the edges of a program. An asynchronous runtime comes later as another backend for the same networks. |
| F4 | A network is data: immutable tables of processes, ports and connections (source process and port, destination process and port, capacity, overflow policy), as the research's port-level multigraph (p. 52, p. 54). The adjacency matrix is derived from them for analysis (reachability, feedback loops, unreachable processes). |
| F5 | An IP has an identity: IPs are Int ids into a packet table (payload, kind, owner, creation tick), so ownership and lifetime are explicit (Morrison: an IP is owned by exactly one process or connection at a time, and must be sent or dropped). Payloads are numbers until X_eTaL has algebraic data (ask X1). |
| F6 | A connection is a bounded FIFO with a positive capacity. Its overflow policy is explicit: block the producer (the default, backpressure), drop oldest, drop newest, or reject (the research, pp. 46-48). Persistent and rerouting connections are microservices' concern. |
| F7 | A component is a pure step function, `(state, inputs) -> (state, outputs)`, of one type for every component, held boxed in a vector (boxes of functions work at the known-good commit, docs/audit.md), so the scheduler stays ordinary X_eTaL with no dispatch on a kind. Parameters come from initial information packets (IIPs). A composite component is a subnetwork with exported ports, flattened before it runs. |
| F8 | Ports are named and directed. The research's bounded-connection diagram (p. 40) is the model: a producer with `OUT` and `ERR` output ports, a consumer with `IN` and `CTRL` input ports, each connection with its own capacity. Array ports (indexed ports) follow. |
| F9 | Macros only where they solve a problem a function cannot (X_eTaL-libraries' rule): a network DSL (`n_etwork<`) that checks names and builds the tables when the program is compiled is warranted; a macro for each component is not. |
| F10 | Missing X_eTaL features and X_eTaL bugs go in `docs/xetal-asks.md`; X_eTaL is not changed from here, and a workaround is named, not hidden. |
| F11 | Demos teach: each shows the X_eTaL source, the tables and the intermediate arrays, as the other X_eTaL explorers do. The first is the Classical FBP Explorer (the research, p. 71): Generate -> Transform -> Filter -> Collect, with rates, capacities, packets and scheduling events visible. A browser page comes after the command-line version, and shows only what X_eTaL prints or draws. |
| F12 | Pinned upstreams: X_eTaL at `XETAL_COMMIT` (work/xetal, bin/xetal) and X_eTaL-libraries at `LIBRARIES_COMMIT` (work/libraries), both clones gitignored, moved only at a saga start or when an ask lands, in a commit of their own. |

## Acceptance tests taken from the research

- Backpressure (p. 47): a producer offering 12 IPs per second into a
  connection of capacity 16 drained by a consumer taking 8 per second
  fills it by second 4 (occupancy 4 8 12 16 16 ...), and over 12
  seconds 32 offered IPs are not admitted (4 per second for the 8
  seconds the connection is full), utilization 100%; raising the
  capacity delays saturation but does not remove the mismatch.
- The bounded connection (p. 40): a connection reports its occupancy
  ("3 of 5 slots occupied"), and a process's two output ports feed two
  independent connections.
- The order-processing network (p. 52): a port-level network with
  feedback paths, several input ports per process and capacities per
  connection is accepted, validated and its feedback loops found; it is
  not a DAG.
- The Classical FBP Explorer (p. 71): Generate -> Transform -> Filter
  -> Collect runs deterministically, and changing a rate or a capacity
  changes the trace in the expected way.

## Roadmap

The research's FBP phases (p. 69: research, core semantics, simulator,
components, visualization, overlapping) map onto sagas below. Each
step ends with the gate passing, docs updated, a detailed commit to
`main` pushed, and a report.

### Saga 1 -- foundations (active)

| # | Step | What |
| - | ---- | ---- |
| 1 | setup (done) | Repository scaffolding after X_eTaL-libraries: CLAUDE.md/AGENTS.md with the agentrail briefing, README with copyright and license, CHANGES.md, justfile and scripts (pinned xetal and libraries, reg-rs tests, gate, spelling), this plan, the asks file, the saga. |
| 2 | capability-audit (done) | `docs/audit.md`: probe the known-good X_eTaL for every FBP need (tuples as loop state, boxes of functions, deep recursion, ring buffers by amend, records and sums, streams, effects, macros, drawing), with a small program per finding; record asks. |
| 3 | connections | `libs/Connections`: a bounded FIFO as an array, offer and take, occupancy, the four overflow policies, counts of admitted, blocked and dropped IPs; the p. 47 backpressure acceptance as a test and a demo. |
| 4 | packets | `libs/Packets`: the IP table, create, send, receive and drop with ownership checked (an IP never in two places, never lost), bracket IPs marking substreams. |
| 5 | networks | `libs/Networks`: processes, ports and connections as tables; validation (endpoints exist, an output feeds an input, capacity positive, every required port connected, an input fed once); the adjacency matrix, reachability, feedback loops (X_eTaL-libraries' Graphs); the p. 52 network as a test. |
| 6 | scheduler | `libs/Scheduler`: components as boxed step functions, IIPs, end of stream, a deterministic tick (each eligible process runs once, in a fixed order), the run's trace as a table (tick, process, event, IP), termination and a deadlock report (no process can run while IPs wait). |
| 7 | components | `libs/Components`: the first standard components (generate, map, filter, collect, copy, merge, router, batch, throttle), each tested alone and in a network. |
| 8 | network-dsl | `n_etwork<` in a `.xtlm`: the port-level text of p. 52 (`gateway.OUT -> validate.IN [64]`) becomes the tables when the program is compiled, a misspelled process or port refused there. |
| 9 | explorer-cli | The Classical FBP Explorer on the command line: the p. 71 network, occupancy per tick printed and drawn (`[]S_HOW`), the scheduling trace, parameters to vary. |

### Saga 2 -- structure (planned)

Substreams and bracket IPs in components (group, ungroup, collate),
composite components (subnetworks with exported ports), cyclic
networks and feedback, selective receipt (a process choosing which port
to read), control IPs, deadlock analysis (wait-for graph from the
trace, static risk from the tables), array ports.

### Saga 3 -- the explorer in the browser (planned)

The Classical FBP Explorer as a live page, following X_eTaL-games' and
X_eTaL-libraries' page patterns (the page shows only what X_eTaL prints
or draws): stepping, packet inspection, capacity and rate controls.

### Saga 4 -- beyond simulation (planned)

A pattern catalog as data (Morrison's concepts and his 2005 patterns,
with status, tests and demos), checkpointing, performance (batching,
capacities), an asynchronous runtime through X_eTaL-extensions, and
the interface X_eTaL-microservices needs (agreed with that repository:
components, IPs, ports, connections, networks; deployment boundaries
stay there).

## Open questions

- Payload types: numbers only until ask X1 (algebraic data) lands, or
  boxed text as well in the meantime?
- Time: one tick per scheduler round, or rates in IPs per second with
  a fixed tick length (the p. 47 experiment is per second)?
- Library names and aliases: `Connections` (`cn:`), `Packets` (`ip:`),
  `Networks` (`nw:`), `Scheduler` (`sc:`), `Components` (`co:`) are
  proposed; none collides with X_eTaL's standard libraries or
  X_eTaL-libraries'.
- The local port for this repository's pages: 8487 (unused by the
  other X_eTaL repositories) is proposed.
