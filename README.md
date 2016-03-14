# Changeset

An Elixir package for calculating between-list edit distances.

It can calculate both the [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between two lists and the actual edit steps required to go from one list to another (using the [Wagner-Fischer algorithm](https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm)).

```elixir
iex> taylor_swift_songs = [22, 15, "I Knew You Were Trouble"]
iex> positive_integers = [22, 7, 15, 186, 33]

# Levenshtein.
iex> Changeset.levenshtein(taylor_swift_songs, positive_integers)
3

# Edit steps.
iex> Changeset.edits(taylor_swift_songs, positive_integers)
[{:insert, 7, 1}, {:substitute, 186, 3}, {:insert, 33, 4}]

iex> Changeset.edits(positive_integers, taylor_swift_songs)
[{:delete, 7, 1}, {:substitute, "I Knew You Were Trouble", 2}, {:delete, 33, 4}]

# Edit steps include moves (i.e. deletions followed by insertions).
iex> Changeset.edits(~w( a v e r y ), ~w( g a r v e y ))
[{:insert, "g", 0}, {:move, "r", 3, 2}]

# It is also possible to give the edits function a custom cost function.
iex> Changeset.edits(~w( a b c ), ~w( a d c ))
[{:substitute, "d", 1}]
iex> Changeset.edits(~w( a b c ), ~w( a d c ), fn type, _value, _idx ->
...>   if type == :substitute, do: 3, else: 1
...> end)
[{:insert, "d", 1}, {:delete, "b", 1}]
```

## Installation

Changeset can be installed by adding it to `mix.exs`:

```elixir
def deps do
  [{:changeset, "~> 0.2.1"}]
end
```

## Tests and benchmarks

Run tests:

```sh
$ mix test
................

Finished in 0.1 seconds (0.1s on load, 0.01s on tests)
16 tests, 0 failures
```

Run benchmarks (using [benchfella](https://github.com/alco/benchfella)):

```sh
$ mix bench
Settings:
  duration:      1.0 s

## ChangesetBench
[15:58:58] 1/3: `preterit` <-> `zeitgeist` levenshtein distance
[15:59:00] 2/3: `preterit` -> `zeitgeist` edit steps
[15:59:04] 3/3: `mark antony` -> `another man` edit steps

Finished in 6.95 seconds

## ChangesetBench
`preterit` <-> `zeitgeist` levenshtein distance      500000   4.33 µs/op
`preterit` -> `zeitgeist` edit steps                 200000   9.81 µs/op
`mark antony` -> `another man` edit steps            100000   11.01 µs/op
```

## Changelog

### 0.2.1

* Adds [memoization](https://wiki.haskell.org/Memoization) (using the [DefMemo](https://github.com/os6sense/DefMemo) package), dramatically improving the performance. The `levenshtein/2` function is now ~99.8% faster and the `edits/2` and `edits/3` functions are ~99.9% faster (which is another way of saying that they were very inefficient before).

### 0.2.0

* There is now an `edits/3` function that takes a custom cost function as an argument.
* The performance of the `edits/2` and `edits/3` functions has been slightly improved.
