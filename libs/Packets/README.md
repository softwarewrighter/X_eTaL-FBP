# Packets

Information packets (IPs) with identity: a table of every IP's kind,
payload, owner and creation tick, ownership checked on every move, an
audit against the connections' contents, and bracket IPs delimiting
substreams.

```
"ip:" u_se< "Packets"
```

| Directory | What |
| --------- | ---- |
| [`src/`](src/) | the library, `Packets.xtl` |
| [`docs/`](docs/README.md) | the reference: every function, its type, examples |
| [`demos/`](demos/) | the life of five IPs through a connection |
| [`tests/`](tests/) | reg-rs baselines: the test programs, the pinned export types (`types.rgt`) and the demos (`demo-*.rgt`) |

```bash
just demo Packets lifecycle   # run the demo
just run Packets              # run its test programs
just test-lib Packets         # check every baseline
```
