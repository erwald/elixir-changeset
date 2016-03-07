defmodule ChangesetTest do
  use ExUnit.Case
  doctest Changeset

  setup do
    source = ["Kant", "Nietzsche", "Wittgenstein", "Marx", "Proudhon"]
    target = ["Heidegger", "Kant", "Nietzsche", "Schopenhauer", "Marx"]
    {:ok, source: source, target: target}
  end

  test "difference", %{source: source, target: target} do
    {l, r} = Changeset.difference(source, target)
    assert l == ["Wittgenstein", "Proudhon"]
    assert r == ["Heidegger", "Schopenhauer"]
  end

  test "edit distance", %{source: source, target: target} do
    edits = Changeset.distance(source, target)
    assert edits == [
      {:insertion, "Heidegger", 0},
      {:substitution, "Schopenhauer", 3},
      {:deletion, nil, 5}
    ]
  end

  test "reverse edit distance", %{source: source, target: target} do
    edits = Changeset.distance(target, source)
    assert edits == [
      {:deletion, "Heidegger", 0},
      {:substitution, "Wittgenstein", 2},
      {:insertion, "Proudhon", 4}
    ]
  end
end
