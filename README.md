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

The resulting indices reflect edits where *deletions are made first*, before insertions and substitutions. That is, indices for deletions refer to the source collection, whereas indices for insertions and substitutions refer to the latter, intermediate collections.

An example will serve. Calling `edits/2` on "preterit" and "zeitgeist" returns the following:

```elixir
[
  {:substitute, "z", 0},
  {:delete, "r", 1},
  {:insert, "i", 2},
  {:insert, "g", 4},
  {:delete, "r", 5},
  {:insert, "s", 7}
]
```

Let's look at these steps in order, keeping in mind that deletions are made first:

1. Deleting at index 1 in "p**r**eterit" gives "peterit".
2. Deleting at index 5 in "prete**r**it" gives "peteit".
3. Substituting "z" at index 0 in "**p**eteit" gives "**z**eteit".
4. Inserting "i" at index 2 in "zeteit" gives "ze**i**teit".
5. Inserting "g" at index 4 in "zeiteit" gives "zeit**g**eit".
6. Inserting "s" at index 7 in "zeitgeit" gives "zeitgei**s**t".

## Installation

Changeset can be installed by adding it to `mix.exs`:

```elixir
def deps do
  [{:changeset, "~> 0.2.2"}]
end
```

## Tests and benchmarks

Run tests:

```sh
$ mix test
................

Finished in 0.1 seconds
16 tests, 0 failures
```

Run benchmarks (using [benchfella](https://github.com/alco/benchfella)):

```sh
$ mix bench
Settings:
  duration:      1.0 s

## ChangesetBench
[17:47:11] 1/4: `figurine` <-> `ligature` (as binaries) levenshtein distance
[17:47:14] 2/4: `mark antony` -> `another man` edit steps
[17:47:15] 3/4: `preterit` -> `zeitgeist` edit steps
[17:47:18] 4/4: `preterit` <-> `zeitgeist` levenshtein distance

Finished in 9.54 seconds

## ChangesetBench
benchmark name                                                iterations   average time
`preterit` <-> `zeitgeist` levenshtein distance                   500000   3.72 µs/op
`figurine` <-> `ligature` (as binaries) levenshtein distance      500000   5.53 µs/op
`preterit` -> `zeitgeist` edit steps                              200000   8.56 µs/op
`mark antony` -> `another man` edit steps                         100000   10.09 µs/op
```

## Contributing

Contributions are welcome. Just open up an issue if you've found a problem or have a suggestion for a feature, or a pull request if you already know how to fix or implement it.

## Changelog

### 1.0.0

* Minor updates for Elixir 1.4.

### 0.2.2

* Adds support for binaries (courtesy @mwmiller).

### 0.2.1

* Adds [memoization](https://wiki.haskell.org/Memoization) (using the [DefMemo](https://github.com/os6sense/DefMemo) package), dramatically improving performance. The `levenshtein/2` function is now ~99.8% faster and the `edits/2` and `edits/3` functions are ~99.9% faster (which is another way of saying that they were very inefficient before).

### 0.2.0

* There is now an `edits/3` function that takes a custom cost function as an argument.
* The performance of the `edits/2` and `edits/3` functions has been slightly improved.
