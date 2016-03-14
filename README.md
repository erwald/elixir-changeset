# Changeset

An Elixir package for calculating between-list edit distances.

It can calculate both the [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between two lists or binaries and the actual edit steps required to go from one list/binary to another (using the [Wagner-Fischer algorithm](https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm)).

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
iex> Changeset.edits("avery", "garvey")
[{:insert, "g", 0}, {:move, "r", 3, 2}]

# It is also possible to give the edits function a custom cost function.
iex> Changeset.edits("abc", "adc")
[{:substitute, "d", 1}]
iex> Changeset.edits("abc", "adc", fn type, _value, _idx ->
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

Finished in 0.2 seconds (0.1s on load, 0.01s on tests)
16 tests, 0 failures
```

Run benchmarks (using [benchfella](https://github.com/alco/benchfella)):

```sh
$ mix bench
Settings:
  duration:      1.0 s

## ChangesetBench
[22:43:21] 1/4: `preterit` <-> `zeitgeist` levenshtein distance
[22:43:24] 2/4: `preterit` -> `zeitgeist` edit steps
[22:43:26] 3/4: `mark antony` -> `another man` edit steps
[22:43:28] 4/4: `figurine` <-> `ligature` (as binaries) levenshtein distance

Finished in 8.52 seconds

## ChangesetBench
`preterit` <-> `zeitgeist` levenshtein distance                   200000   9.37 µs/op
`figurine` <-> `ligature` (as binaries) levenshtein distance      100000   12.51 µs/op
`preterit` -> `zeitgeist` edit steps                              100000   17.67 µs/op
`mark antony` -> `another man` edit steps                         100000   19.61 µs/op
```

## Changelog

### 0.2.2
*(in development)*

* Adds support for binaries (courtesy @mwmiller).

### 0.2.1

* Adds [memoization](https://wiki.haskell.org/Memoization) (using the [DefMemo](https://github.com/os6sense/DefMemo) package), dramatically improving performance. The `levenshtein/2` function is now ~99.8% faster and the `edits/2` and `edits/3` functions are ~99.9% faster (which is another way of saying that they were very inefficient before).

### 0.2.0

* There is now an `edits/3` function that takes a custom cost function as an argument.
* The performance of the `edits/2` and `edits/3` functions has been slightly improved.
