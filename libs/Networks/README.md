# Networks

FBP networks as data: processes with named input and output ports,
and the bounded connections between them, as tables; checked while
they are built, then validated (every required port connected) and
analyzed (adjacency, feedback loops, sources, sinks, reachability).

```
"nw:" u_se< "Networks"
```

| Directory | What |
| --------- | ---- |
| [`src/`](src/) | the library, `Networks.xtl` |
| [`docs/`](docs/README.md) | the reference: every function, its type, examples |
| [`demos/`](demos/) | the order-processing network, analyzed |
| [`tests/`](tests/) | reg-rs baselines: the test programs, the pinned export types (`types.rgt`) and the demos (`demo-*.rgt`) |

```bash
just demo Networks order   # run the demo
just run Networks          # run its test programs
just test-lib Networks     # check every baseline
```
