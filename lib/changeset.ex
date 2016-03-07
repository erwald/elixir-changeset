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
  def edit_steps(source, target), do: steps(source, target, [])

  defp steps(source, target, result) do
    []
  end


  @doc """
  Calculate the the edit distance between two lists, i.e. how many insertions,
  deletions or substitutions are required to turn list A into list B.
  """
  @spec distance([], []) :: non_neg_integer
  def distance(source, target), do: dist(source, target, Enum.count(source), Enum.count(target))

  defp dist(_source, _target, i, 0), do: i
  defp dist(_source, _target, 0, j), do: j
  defp dist(source, target, i, j) do
    if Enum.fetch!(source, i - 1) == Enum.fetch!(target, j - 1) do
      dist(source, target, i - 1, j - 1)
    else
      Enum.min([
        dist(source, target, i - 1, j) + 1,
        dist(source, target, i, j - 1) + 1,
        dist(source, target, i - 1, j - 1) + 1
        ])
    end
  end
end
