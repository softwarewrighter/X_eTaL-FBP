# Connections

Bounded connections between FBP processes: a FIFO of information
packets with a fixed capacity and an overflow policy (block the
producer, drop oldest, drop newest, reject).

```
"cn:" u_se< "Connections"
```

| Directory | What |
| --------- | ---- |
| [`src/`](src/) | the library, `Connections.xtl` |
| [`docs/`](docs/README.md) | the reference: every function, its type, examples |
| [`demos/`](demos/) | the backpressure experiment, the four policies side by side |
| [`tests/`](tests/) | reg-rs baselines: the test programs, the pinned export types (`types.rgt`) and the demos (`demo-*.rgt`) |

```bash
just demo Connections backpressure   # run a demo
just run Connections                  # run its test programs
just test-lib Connections             # check every baseline
```
