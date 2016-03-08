# Changeset

A package for calculating differences between lists.

It can check for differences (which items are in this list but not in that one and vice versa?), [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance) and the actual edit steps required to go from one list to another (using the [Wagner-Fischer algorithm](https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm)).

```elixir
iex(1)> taylor_swift_songs = [22, 15, "I Knew You Were Trouble"]
iex(2)> positive_integers = [22, 7, 15, 186, 33]

# Differences.
iex(3)> Changeset.difference(taylor_swift_songs, positive_integers)
{["I Knew You Were Trouble"], [7, 186, 33]}

# Levenshtein.
iex(4)> Changeset.levenshtein(taylor_swift_songs, positive_integers)
3

# Edit steps.
iex(5)> Changeset.edit_steps(taylor_swift_songs, positive_integers)
[{:insert, 7, 1}, {:substitute, 186, 3}, {:insert, 33, 4}]

iex(6)> Changeset.edit_steps(positive_integers, taylor_swift_songs)
[{:delete, 7, 1}, {:substitute, "I Knew You Were Trouble", 2}, {:delete, 33, 4}]
```

## Installation

Changeset can be installed like so:

  1. Add changeset to your list of dependencies in `mix.exs`:

  ```elixir
    def deps do
      [{:changeset, "~> 0.0.1"}]
    end
  ```

  2. Ensure changeset is started before your application:

  ```elixir
    def application do
      [applications: [:changeset]]
    end
  ```

## Tests and benchmarks

Run tests:

```sh
mix test
```

Run benchmarks (using [benchfella](https://github.com/alco/benchfella)):

```sh
mix bench
```
