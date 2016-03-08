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
  @spec edit_steps([], []) :: [{atom, any, non_neg_integer}]
  def edit_steps(source, target) do
    {res, _} = stp(source, target, [], Enum.count(source), Enum.count(target))
    res |> reduce_edit_steps
  end

  defp stp(_src, _tgt, res, 0, 0), do: {res, 0}
  defp stp(src, tgt, res, i, 0) do
    {res, cost} = stp(src, tgt, mk_tup(:delete, src, i) ++ res, i - 1, 0)
    {res, cost + 1}
  end
  defp stp(src, tgt, res, 0, j) do
    {res, cost} = stp(src, tgt, mk_tup(:insert, tgt, j) ++ res, 0, j - 1)
    {res, cost + 1}
  end
  defp stp(src, tgt, res, i, j) do
    if Enum.fetch!(src, i - 1) == Enum.fetch!(tgt, j - 1) do
      stp(src, tgt, res, i - 1, j - 1)
    else
      [
        stp(src, tgt, mk_tup(:delete, src, i) ++ res, i - 1, j),
        stp(src, tgt, mk_tup(:insert, tgt, j) ++ res, i, j - 1),
        stp(src, tgt, mk_tup(:substitute, tgt, j) ++ res, i - 1, j - 1)
      ]
      |> Enum.map(fn {res, cost} -> {res, cost + 1} end)
      |> Enum.min_by(fn {_, cost} -> cost end)
    end
  end

  defp mk_tup(type, list, dest) do
    [{type, Enum.fetch!(list, dest - 1), dest - 1}]
  end

  defp reduce_edit_steps(edit_steps) do
    edit_steps
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
