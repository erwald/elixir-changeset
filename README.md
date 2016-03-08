# Changeset

An Elixir package for calculating between-list edit distances.

It can calculate both the [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) between two lists and the actual edit steps required to go from one list to another (using the [Wagner-Fischer algorithm](https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm)).

```elixir
iex(1)> taylor_swift_songs = [22, 15, "I Knew You Were Trouble"]
iex(2)> positive_integers = [22, 7, 15, 186, 33]

# Levenshtein.
iex(3)> Changeset.levenshtein(taylor_swift_songs, positive_integers)
3

# Edit steps.
iex(4)> Changeset.edits(taylor_swift_songs, positive_integers)
[{:insert, 7, 1}, {:substitute, 186, 3}, {:insert, 33, 4}]

iex(5)> Changeset.edits(positive_integers, taylor_swift_songs)
[{:delete, 7, 1}, {:substitute, "I Knew You Were Trouble", 2}, {:delete, 33, 4}]

# Edit steps include moves (i.e. deletions followed by insertions).
iex(6)> Changeset.edits(~w( a v e r y ), ~w( g a r v e y))
[{:insert, "g", 0}, {:move, "r", 3, 2}]
```

## Installation

Changeset can be installed by adding it to `mix.exs`:

```elixir
def deps do
  [{:changeset, "~> 0.1"}]
end
```

## Tests and benchmarks

Run tests:

```sh
$ mix test
.............

Finished in 0.1 seconds (0.1s on load, 0.03s on tests)
13 tests, 0 failures
```

Run benchmarks (using [benchfella](https://github.com/alco/benchfella)):

```sh
$ mix bench
Settings:
  duration:      1.0 s

## ChangesetBench
[17:36:35] 1/2: preterit <-> zeitgeist levenshtein distance
[17:36:38] 2/2: preterit -> zeitgeist edit steps

Finished in 6.97 seconds

## ChangesetBench
preterit <-> zeitgeist levenshtein distance        1000   2150.54 µs/op
preterit -> zeitgeist edit steps                    500   7499.73 µs/op
```
