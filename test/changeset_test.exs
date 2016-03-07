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

  test "edit steps", %{source: source, target: target} do
    edits = Changeset.edit_steps(source, target)
    assert edits == [
      {:insertion, "Heidegger", 0},
      {:substitution, "Schopenhauer", 3},
      {:deletion, nil, 5}
    ]
  end

  test "reverse edit steps", %{source: source, target: target} do
    edits = Changeset.edit_steps(target, source)
    assert edits == [
      {:deletion, "Heidegger", 0},
      {:substitution, "Wittgenstein", 2},
      {:insertion, "Proudhon", 4}
    ]
  end

  test "edit distance", %{source: source, target: target} do
    assert Changeset.distance(source, target) == 3
    assert Changeset.distance(target, source) == 3
  end
end
