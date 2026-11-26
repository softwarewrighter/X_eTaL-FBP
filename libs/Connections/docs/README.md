# Connections

Bounded connections between FBP processes: a FIFO of information
packets (IPs) with a fixed capacity and an overflow policy.

```
"cn:" u_se< "Connections"
```

Put each library's `src/` directory on `XETAL_PATH` (`scripts/xt`
does; see the [README](../../../README.md)); `cn:` is the recommended
alias.

In flow-based programming, processes never call each other: a
producer sends IPs into a connection and a consumer receives them from
it, and the connection holds at most its capacity. When it is full,
what happens to the IPs that do not fit is the connection's overflow
policy. The default of classical FBP is to block the producer until
there is room (backpressure), so memory stays bounded and a slow
consumer slows its producers.

```
  producer --OUT-->[ 3 | 2 | 1 |   |   ]--IN--> consumer     3 of 5 slots occupied
```

A connection is a value, the tuple `(capacity, policy, contents,
counts)`: contents are the queued IPs' ids, oldest first; counts are
how many IPs it has admitted, blocked, rejected, dropped and
delivered. Sending and receiving give a new connection.

## Overflow policies

| Policy | IPs that do not fit | Use |
| ------ | ------------------- | --- |
| `cn:Block` | stay with the producer, which offers them again (backpressure) | the default, for loss-intolerant processing |
| `cn:Reject` | go back to the producer, refused, for it to deal with | explicit admission control |
| `cn:DropNewest` | are dropped | best-effort event streams |
| `cn:DropOldest` | all are admitted; the oldest queued IPs are dropped to make room | replaceable telemetry (the latest reading matters) |

## Functions

| Function | Type | What |
| -------- | ---- | ---- |
| `cn:n_ew (capacity, policy)` | `(a, b) -> connection` | an empty connection; a capacity below 1 is `error[bad-capacity]`, a policy not one of the four `error[bad-policy]` |
| `c cn:s_end ips` | `connection -> Int -> (connection, Int)` | the IPs offered in order; gives the connection and the IPs given back (under `cn:Block` still the producer's, under `cn:Reject` refused; empty under the drop policies) |
| `n cn:r_eceive c` | `Int -> connection -> (connection, Int)` | the oldest n IPs delivered (all of them when fewer are queued), and the connection without them |
| `cn:c_apacity c` | `connection -> Int` | how many IPs it holds at most |
| `cn:p_olicy c` | `connection -> Int` | its overflow policy, 1 to 4 |
| `cn:c_ontents c` | `connection -> Int` | the queued IPs, oldest first |
| `cn:c_ounts c` | `connection -> Int` | admitted, blocked, rejected, dropped, delivered |
| `cn:o_ccupancy c` | `connection -> Int` | how many IPs are queued |
| `cn:r_oom c` | `connection -> Int` | how many more fit |
| `cn:e_mpty? c`, `cn:f_ull? c` | `connection -> Bool` | nothing queued; nothing more fits |
| `cn:u_tilization c` | `connection -> Float` | the share of the capacity in use |
| `cn:d_escribe c` | `connection -> Char` | `3 of 5 slots occupied` |
| `(rate, take, seconds) cn:r_un c` | `(Int, Int, Int) -> connection -> (connection, Int)` | a producer offering rate IPs a second into c and a consumer taking up to take a second, for that many seconds; gives the connection and a table, a row per second: second, offered, admitted, not admitted, delivered, occupancy |

The exact inferred types are pinned in `../tests/types.out`.

In `cn:r_un`, each second the consumer takes what is queued, the
producer offers its rate (under `cn:Block` the IPs it was left
holding first, then new ones, so it never holds more than its rate),
and the consumer takes what arrived, up to its rate in all: producer
and consumer work during the same second.

## Examples

From `../tests/basics.xtl` and `../tests/policies.xtl`:

```
      c := cn:n_ew (5, cn:Block)
      (c1, back) := c cn:s_end 1 2 3
      cn:d_escribe c1
3 of 5 slots occupied
      (c2, got) := 2 cn:r_eceive c1
      got
1 2
```

Offered 11 to 16 when 1 and 2 are queued and the capacity is 5, a
`cn:Block` connection queues `1 2 11 12 13` and gives back `14 15 16`;
a `cn:DropOldest` one queues `12 13 14 15 16`.

The backpressure experiment, from `../tests/backpressure.xtl`: a
producer offering 12 IPs a second into a connection of capacity 16,
drained at 8 a second, fills it by second 4, and over 12 seconds 32
offered IPs are not admitted (4 a second for the 8 seconds it is
full). A capacity of 32 delays saturation to second 8 but still turns
away 16: capacity buys time, not throughput.

```
      (c, t) := (12, 8, 12) cn:r_un cn:n_ew (16, cn:Block)
      6 s_elect_2 t
4 8 12 16 16 16 16 16 16 16 16 16
      '+ r_/ 4 s_elect_2 t
32
```

## Demos

- [`demos/backpressure.xtl`](../demos/backpressure.xtl): the experiment
  at capacities 16 and 32, as tables, bars and a chart.
- [`demos/policies.xtl`](../demos/policies.xtl): the same experiment
  under each of the four policies, their counts side by side.

## Provenance

Written for X_eTaL-FBP. The model is J. Paul Morrison's bounded
connections (*Flow-Based Programming*, 1994 and 2010); the policies and
the backpressure experiment come from this repository's research notes
(`docs/research.pdf`, pp. 40 and 46-48).
