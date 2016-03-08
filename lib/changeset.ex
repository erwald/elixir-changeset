defmodule Changeset do

  @doc """
  Calculate the differences between two lists, returning a tuple of the items
  existing in list A but not in list B and the items that are in list B but not
  in list A.
  """
  @spec difference([], []) :: {[], []}
  def difference(source, target), do: diff(source, target, {[], []})

  defp diff([], [], result), do: result
  defp diff([], r, {l_diff, r_diff}), do: {l_diff, r_diff ++ r}
  defp diff([lhd | ltl], r, {l_diff, r_diff}) do
    if Enum.member?(r, lhd) do
      # If the first element of left-hand list is contained in right-hand list,
      # remove it from both lists and keep going.
      diff(ltl, List.delete(r, lhd), {l_diff, r_diff})
    else
      # Else, add it to the left-hand differences and keep going.
      diff(ltl, r, {l_diff ++ [lhd], r_diff})
    end
  end

  @doc """
  Calculate the the minimal steps (insertions, deletions, substitutions and
  moves) required to turn list A into list B.
  """
  @spec edits([], []) :: [{atom, any, non_neg_integer}]
  def edits(source, target) do
    {res, _} = edt(source, target, [], Enum.count(source), Enum.count(target))
    res |> reduce_moves
  end

  defp edt(_src, _tgt, res, 0, 0), do: {res, 0}
  defp edt(src, tgt, res, i, 0) do
    {res, cost} = edt(src, tgt, [mk_tup(:delete, src, i)] ++ res, i - 1, 0)
    {res, cost + 1}
  end
  defp edt(src, tgt, res, 0, j) do
    {res, cost} = edt(src, tgt, [mk_tup(:insert, tgt, j)] ++ res, 0, j - 1)
    {res, cost + 1}
  end
  defp edt(src, tgt, res, i, j) do
    if Enum.fetch!(src, i - 1) == Enum.fetch!(tgt, j - 1) do
      edt(src, tgt, res, i - 1, j - 1)
    else
      [
        edt(src, tgt, [mk_tup(:delete, src, i)] ++ res, i - 1, j),
        edt(src, tgt, [mk_tup(:insert, tgt, j)] ++ res, i, j - 1),
        edt(src, tgt, [mk_tup(:substitute, tgt, j)] ++ res, i - 1, j - 1)
      ]
      |> Enum.map(fn {res, cost} -> {res, cost + 1} end)
      |> Enum.min_by(fn {_, cost} -> cost end)
    end
  end

  # Takes a edit type (:delete, :insert or :substitute), a list of values and
  # an index, and returns a tuple containing the action type, the affected
  # value and the destination index.
  defp mk_tup(type, list, dest) do
    {type, Enum.fetch!(list, dest - 1), dest - 1}
  end

  # Reduces a list of action steps to combine insertions and deletions of the
  # same value into a single :move action with that value. (These are equivalent
  # anyway, as a deletion and insertion elsewhere of a value A is nothing more
  # than a movement.)
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
  """
  @spec levenshtein([], []) :: non_neg_integer
  def levenshtein(source, target) do
    lev(source, target, Enum.count(source), Enum.count(target))
  end

  defp lev(_source, _target, i, 0), do: i
  defp lev(_source, _target, 0, j), do: j
  defp lev(source, target, i, j) do
    if Enum.fetch!(source, i - 1) == Enum.fetch!(target, j - 1) do
      lev(source, target, i - 1, j - 1)
    else
      Enum.min([
        lev(source, target, i - 1, j) + 1,
        lev(source, target, i, j - 1) + 1,
        lev(source, target, i - 1, j - 1) + 1
        ])
    end
  end
end
