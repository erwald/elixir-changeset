defmodule ChangesetTest do
  use ExUnit.Case
  doctest Changeset

  setup do
    kitten = String.split("kitten", "", trim: true)
    sitting = String.split("sitting", "", trim: true)

    preterit = String.split("preterit", "", trim: true)
    zeitgeist = String.split("zeitgeist", "", trim: true)

    garvey = String.split("garvey", "", trim: true)
    avery = String.split("avery", "", trim: true)

    {:ok,
      kitten: {kitten, sitting},
      preterit: {preterit, zeitgeist},
      garvey: {garvey, avery}
    }
  end

  test "kitten <-> sitting difference", %{kitten: {s1, s2}} do
    {l, r} = Changeset.difference(s1, s2)
    assert l == ["k", "e"]
    assert r == ["s", "i", "g"]
  end

  test "preterit <-> zeitgeist difference", %{preterit: {s1, s2}} do
    {l, r} = Changeset.difference(s1, s2)
    assert l == ["p", "r", "r"]
    assert r == ["z", "g", "i", "s"]
  end

  test "garvey <-> avery difference", %{garvey: {s1, s2}} do
    {l, r} = Changeset.difference(s1, s2)
    assert l == ["g"]
    assert r == []
  end

  test "kitten -> sitting edit steps", %{kitten: {s1, s2}} do
    edits = Changeset.edits(s1, s2)
    assert edits == [
      {:substitute, "s", 0},
      {:substitute, "i", 4},
      {:insert, "g", 6}
    ]
  end

  test "sitting -> kitten edit steps", %{kitten: {s1, s2}} do
    edits = Changeset.edits(s2, s1)
    assert edits == [
      {:substitute, "k", 0},
      {:substitute, "e", 4},
      {:delete, "g", 6}
    ]
  end

  test "garvey -> avery edit steps", %{garvey: {s1, s2}} do
    edits = Changeset.edits(s1, s2)
    assert edits == [
      {:delete, "g", 0},
      {:move, "r", 2, 3}
    ]
  end

  test "avery -> garvey edit steps", %{garvey: {s1, s2}} do
    edits = Changeset.edits(s2, s1)
    assert edits == [
      {:insert, "g", 0},
      {:move, "r", 3, 2}
    ]
  end

  test "preterit -> zeitgeist edit steps", %{preterit: {s1, s2}} do
    edits = Changeset.edits(s1, s2)
    assert edits == [
      {:substitute, "z", 0},
      {:delete, "r", 1},
      {:insert, "i", 2},
      {:insert, "g", 4},
      {:delete, "r", 5},
      {:insert, "s", 7}
    ]
  end

  test "zeitgeist -> preterit edit steps", %{preterit: {s1, s2}} do
    edits = Changeset.edits(s2, s1)
    assert edits == [
      {:substitute, "p", 0},
      {:insert, "r", 1},
      {:delete, "i", 2},
      {:delete, "g", 4},
      {:insert, "r", 5},
      {:delete, "s", 7}
    ]
  end

  test "kitten -> empty string edit steps", %{kitten: {s1, _s2}} do
    edits = Changeset.edits(s1, [])
    assert edits == [
      {:delete, "k", 0},
      {:delete, "i", 1},
      {:delete, "t", 2},
      {:delete, "t", 3},
      {:delete, "e", 4},
      {:delete, "n", 5}
    ]
  end

  test "empty string -> kitten edit steps", %{kitten: {s1, _s2}} do
    edits = Changeset.edits([], s1)
    assert edits == [
      {:insert, "k", 0},
      {:insert, "i", 1},
      {:insert, "t", 2},
      {:insert, "t", 3},
      {:insert, "e", 4},
      {:insert, "n", 5}
    ]
  end

  test "kitten <-> sitting levenshtein distance", %{kitten: {s1, s2}} do
    assert Changeset.levenshtein(s1, s2) == 3
    assert Changeset.levenshtein(s2, s1) == 3
  end

  test "preterit <-> zeitgeist levenshtein distance", %{preterit: {s1, s2}} do
    assert Changeset.levenshtein(s1, s2) == 6
    assert Changeset.levenshtein(s2, s1) == 6
  end

  test "garvey <-> avery levenshtein distance", %{garvey: {s1, s2}} do
    assert Changeset.levenshtein(s1, s2) == 3
    assert Changeset.levenshtein(s2, s1) == 3
  end
end
