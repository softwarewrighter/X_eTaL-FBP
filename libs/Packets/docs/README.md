# Packets

Information packets (IPs) with identity: who owns each one, what it
carries, and the brackets that group them into substreams.

```
"ip:" u_se< "Packets"
```

Put each library's `src/` directory on `XETAL_PATH` (`scripts/xt`
does; see the [README](../../../README.md)); `ip:` is the recommended
alias.

In flow-based programming an IP is a thing, not a value: a process
creates it, it is owned by exactly one process or connection at a
time, and whoever owns it must in the end send it on or discard it
(J. Paul Morrison). That makes lost and duplicated work detectable. This
library keeps one table of every IP, the tuple `(kinds, payloads,
owners, born)`, a column each, IP i in row i:

| Column | Holds |
| ------ | ----- |
| kind | `ip:Data` (1), `ip:Open` (2) or `ip:Close` (3) |
| payload | a number (a Float) |
| owner | a process number (1, 2, ...), a connection as its number negated (`ip:a_tConnection c`), or 0 once discarded |
| born | the tick the IP was created at |

IPs are numbered from 1 in the order they are created; their ids are
what a connection (the Connections library) queues.

## Functions

| Function | Type | What |
| -------- | ---- | ---- |
| `ip:e_mpty @` | `Unit -> table` | a table with no IPs |
| `(kinds, payloads, owner, tick) ip:c_reate t` | `-> table -> (table, Int)` | one new IP per payload, owned by process owner, created at tick; one kind for all or one each; gives the table and the new ids. A non-process owner is `error[not-a-process]` |
| `(ids, from, to) ip:m_ove t` | `-> table -> table` | the IPs passed from owner from to owner to; an IP that does not exist is `error[no-packet]`, a discarded one `error[dropped-packet]`, one from does not own `error[not-owner]` |
| `(ids, owner) ip:d_iscard t` | `-> table -> table` | the IPs discarded (Morrison's drop): owner 0, for good |
| `ip:c_ount t` | `table -> Int` | how many IPs have been created |
| `ip:a_tConnection c` | `Int -> Int` | connection c's owner code, `-c` |
| `ids ip:k_inds t`, `ids ip:p_ayloads t`, `ids ip:o_wners t`, `ids ip:b_orn t` | `Int -> table -> column` | the IPs' kinds, payloads, owners, creation ticks |
| `w ip:o_wnedBy t` | `Int -> table -> Int` | the IPs owner w holds |
| `ip:a_live t` | `table -> Int` | the IPs not discarded |
| `id ip:d_escribe t` | `Int -> table -> Char` | `IP 1: data 2.5, owned by connection 4, created at tick 0` |
| `qs ip:a_udit t` | `Box Int -> table -> Box Char` | what is wrong, a text per problem, given each connection's contents boxed (connection c the c-th box): an IP queued in two places, one queued but not owned by its connection, one its connection owns but does not hold (lost); none when all is well |
| `ip:d_epths kinds` | `Int -> Int` | the bracket depth after each IP of a stream |
| `ip:b_alanced? kinds` | `Int -> Bool` | every open bracket closed, in order |
| `ip:g_roups kinds` | `Int -> Int` | the outermost substream each IP is in (1, 2, ...; its brackets included), 0 outside any |

The exact inferred types are pinned in `../tests/types.out`.

## Examples

From `../tests/basics.xtl`:

```
      (t1, ids) := (ip:Data, 2.5 3.5 4.5, 1, 0) ip:c_reate ip:e_mpty @
      ids
1 2 3
      t3 := (1 2, 1, ip:a_tConnection 4) ip:m_ove t1
      1 ip:d_escribe t3
IP 1: data 2.5, owned by connection 4, created at tick 0
```

From `../tests/refusals.xtl`, a move by a process that does not own
the IP:

```
      (1 2, 2, 3) ip:m_ove t
error[not-owner]: IP 1 is owned by process 1, not process 2
```

From `../tests/brackets.xtl`, the stream open, data, data, open, data,
close, close, data:

```
      ip:d_epths s
1 1 1 2 2 1 0 0
      ip:g_roups s
1 1 1 1 1 1 1 0
```

## Demos

- [`demos/lifecycle.xtl`](../demos/lifecycle.xtl): five IPs created,
  sent into a blocking connection of capacity 3 (two stay with their
  producer), received and discarded, every IP described at each
  stage and the audit run each time; then what the audit finds when a
  receiver forgets to take ownership.

## Provenance

Written for X_eTaL-FBP, after J. Paul Morrison's *Flow-Based
Programming* (1994 and 2010): IPs with identity and ownership, and
bracket IPs delimiting substreams. Kinds are Int codes and payloads
numbers until X_eTaL has records and sum types (docs/xetal-asks.md,
X1).
