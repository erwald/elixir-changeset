defmodule Changeset do
  @moduledoc """
  The Changeset module allows for calculating the Levenshtein distance between
  two lists, or the actual edit steps required to go from one list to another.
  """

  @doc """
  Calculate the the minimal steps (insertions, deletions, substitutions and
  moves) required to turn one given list into another given list.

  ## Examples

      iex> taylor_swift_songs = [22, 15, "I Knew You Were Trouble"]
      [22, 15, "I Knew You Were Trouble"]
      iex> positive_integers = [22, 7, 15, 186, 33]
      [22, 7, 15, 186, 33]
      iex> Changeset.edits(taylor_swift_songs, positive_integers)
      [{:insert, 7, 1}, {:substitute, 186, 3}, {:insert, 33, 4}]
      iex> Changeset.edits(positive_integers, taylor_swift_songs)
      [{:delete, 7, 1}, {:substitute, "I Knew You Were Trouble", 2}, {:delete, 33, 4}]

  It also supports moves, each of which is really only a deletion followed by an
  insertion.

      iex> Changeset.edits(~w( a v e r y ), ~w( g a r v e y))
      [{:insert, "g", 0}, {:move, "r", 3, 2}]

  """
  @spec edits([], []) :: [tuple]
  def edits(source, target) do
    {res, _} = edt(Enum.reverse(source), Enum.reverse(target), [])
    res |> reduce_moves
  end

  defp edt([], [], res), do: {res, 0}
  defp edt([src_hd | src], [], res) do
    {res, cost} = edt(src, [], [{:delete, src_hd, length(src)} | res])
    {res, cost + 1}
  end
  defp edt([], [tgt_hd | tgt], res) do
    {res, cost} = edt([], tgt, [{:insert, tgt_hd, length(tgt)} | res])
    {res, cost + 1}
  end
  defp edt([src_hd | src], [tgt_hd | tgt], res) do
    if src_hd == tgt_hd do
      edt(src, tgt, res)
    else
      [
        edt(src, [tgt_hd] ++ tgt, [{:delete, src_hd, length(src)} | res]),
        edt([src_hd] ++ src, tgt, [{:insert, tgt_hd, length(tgt)} | res]),
        edt(src, tgt, [{:substitute, tgt_hd, length(tgt)} | res])
      ]
      |> Enum.map(fn {res, cost} -> {res, cost + 1} end)
      |> Enum.min_by(fn {_, cost} -> cost end)
    end
  end

  # Reduces a list of action steps to combine insertions and deletions of the
  # same value into a single :move action with that value. (These are equivalent
  # anyway, as a deletion and insertion elsewhere of a certain value is nothing
  # more than a movement of that value.)
  defp reduce_moves(edit_steps) do
    edit_steps
    |> Enum.reduce([], fn step, acc ->
      move = move_from_steps(edit_steps, step)
      if move != nil, do: acc ++ [move], else: acc ++ [step]
    end)
    |> Enum.uniq
  end

  # Takes an edit step and a list of edit steps and returns either a move step
  # if there is one to be found for that edit step, or nil if not.
  defp move_from_steps(edit_steps, step) do
    case elem(step, 0) do
      :insert ->
        find_move(edit_steps, step, :delete)
      :delete ->
        find_move(edit_steps, step, :insert)
      _ ->
        nil
    end
  end

  defp find_move(steps, {type, value, idx}, other_type) do
    # Find the other edit step (i.e. an insertion if the step is a deletion, or
    # a deletion if the step is an insertion).
    other = Enum.find(steps, fn {t, v, _} ->
      t == other_type && v == value
    end)

    # If another edit step was found, create a tuple representing a move based
    # on those two edit steps.
    if other != nil do
      origin_idx = if type == :insert, do: elem(other, 2), else: idx
      destination_idx = if type == :insert, do: idx, else: elem(other, 2)
      {:move, value, origin_idx, destination_idx}
    else
      nil
    end
  end

  @doc """
  Calculate the the Levenshtein distance between two lists, i.e. how many
  insertions, deletions or substitutions are required to turn one given list
  into another.

  ## Examples

      iex> taylor_swift_songs = [22, 15, "I Knew You Were Trouble"]
      [22, 15, "I Knew You Were Trouble"]
      iex> positive_integers = [22, 7, 15, 186, 33]
      [22, 7, 15, 186, 33]
      iex> Changeset.levenshtein(taylor_swift_songs, positive_integers)
      3

  """
  @spec levenshtein([], []) :: non_neg_integer
  def levenshtein(source, target) do
    lev(Enum.reverse(source), Enum.reverse(target))
  end

  defp lev(source, []), do: length(source)
  defp lev([], target), do: length(target)
  defp lev([src_hd | source], [tgt_hd | target]) do
    if src_hd == tgt_hd do
      lev(source, target)
    else
      Enum.min([
        lev(source, [tgt_hd | target]) + 1,
        lev([src_hd | source], target) + 1,
        lev(source, target) + 1
        ])
    end
  end
end
