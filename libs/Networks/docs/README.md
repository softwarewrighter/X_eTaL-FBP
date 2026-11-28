# Networks

FBP networks as data: processes, their named ports, and the bounded
connections between them.

```
"nw:" u_se< "Networks"
```

Put each library's `src/` directory on `XETAL_PATH`, and
X_eTaL-libraries' too (this library uses its Strings and Graphs;
`scripts/xt` does both; see the [README](../../../README.md)); `nw:`
is the recommended alias.

In flow-based programming the network is defined apart from the
components: a component knows only its own ports, and the network
says which output port feeds which input port, through a connection
of what capacity (J. Paul Morrison). Because the network is data, it
can be checked before anything runs and analyzed as a graph.

A network is the tuple `(names, ports, connections)`:

| Part | Holds |
| ---- | ----- |
| names | the processes' names, boxed; process k is the k-th |
| ports | columns `(process, name, direction, optional)`; port i is the i-th row |
| connections | an Int matrix, a row each: from-process, from-port, to-process, to-port, capacity, policy (the Connections library's `cn:Block` and the others, 1 to 4) |

As in classical FBP an output port feeds exactly one connection (to
send IPs two ways, a component copies them), while an input port may
be fed by several connections, which merge.

## Functions

| Function | What |
| -------- | ---- |
| `nw:e_mpty @` | a network with no processes |
| `(name, ins, outs) nw:p_rocess n` | n with a process added; its input and output ports are the words of ins and outs (`"IN CTRL?"`), a port ending in `?` optional |
| `(from, to, capacity, policy) nw:c_onnect n` | n with a connection from the output port from to the input port to, each written `process.PORT` |
| `nw:p_rocesses n` | the processes' names |
| `name nw:p_rocessNumber n` | a process's number |
| `nw:p_orts n` | every port as `process.PORT` |
| `nw:p_ortProcesses n`, `nw:d_irections n`, `nw:o_ptional n` | each port's process, direction (`nw:In`, `nw:Out`), and whether it is optional |
| `nw:c_onnections n` | the connections matrix |
| `nw:l_isting n` | each connection as text, `gen.OUT -> dbl.IN [4]` |
| `nw:p_roblems n` | what makes n incomplete, a text each: a required port not connected, a process connected to nothing |
| `nw:a_djacency n` | the processes' adjacency matrix: item i j is 1 when a connection runs from i to j |
| `nw:l_oops n` | whether each process is on a feedback loop |
| `nw:a_cyclic? n` | whether no process is on a feedback loop |
| `nw:s_ources n`, `nw:s_inks n` | the processes no connection feeds; those that feed none |
| `p nw:r_eachable n` | whether IPs from process p can reach each process |

The inferred types are pinned in `../tests/types.out`. Where they
show `Never` for a part of the network that only passes through, that
is an X_eTaL inference bug (docs/xetal-asks.md, X3); the functions
take and give the parts as described.

Refused while building, each with its own error code: a process or
port name used twice (`duplicate-process`, `duplicate-port`), a name
that is empty or holds a dot or a blank (`bad-name`), an endpoint not
written `process.PORT` (`bad-endpoint`), naming no process or no port
(`no-process`, `no-port`), a connection the wrong way round
(`bad-direction`), a capacity below 1 (`bad-capacity`), a policy not 1
to 4 (`bad-policy`), an output port already connected
(`output-taken`).

## Examples

From `../tests/basics.xtl`:

```
      n0 := ("gen", "", "OUT") nw:p_rocess nw:e_mpty @
      n1 := ("dbl", "IN", "OUT ERR?") nw:p_rocess n0
      n2 := ("show", "IN CTRL?", "") nw:p_rocess n1
      n3 := ("gen.OUT", "dbl.IN", 4, cn:Block) nw:c_onnect n2
      n := ("dbl.OUT", "show.IN", 2, cn:DropOldest) nw:c_onnect n3
      nw:c_onnections n
1 1 2 2 4 1
2 3 3 5 2 2
```

From `../tests/order.xtl`, the order-processing network of the
research (p. 52), six processes and ten connections: every port is
connected, it is not a DAG, and every process but the audit is on a
feedback loop (`nw:l_oops n` is `1 1 1 1 1 0`).

From `../tests/refusals.xtl`:

```
      ("a.ERR", "b.IN", 1, 1) nw:c_onnect n0
error[no-port]: there is no port a.ERR
```

## Demos

- [`demos/order.xtl`](../demos/order.xtl): the order-processing
  network listed, measured and analyzed, its adjacency drawn; then the
  same network without its audit process, and what validation finds.

## Provenance

Written for X_eTaL-FBP, after J. Paul Morrison's *Flow-Based
Programming* (1994 and 2010): externally defined networks of
processes, named ports and bounded connections; the order-processing
network comes from this repository's research notes
(`docs/research.pdf`, p. 52). The graph analysis is X_eTaL-libraries'
Graphs.
