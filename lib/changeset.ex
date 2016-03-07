defmodule Changeset do

  @doc """
  Calculate the differences between two lists, returning a tuple of the items
  existing in list A but not in list B and the items that are in list B but not
  in list A.
  """
  @spec difference([], []) :: {[], []}
  def difference(source, target) do
    difference(source, target, {[], []})
  end

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
  Calculate the edit distance between two lists, i.e. the minimal steps required
  to go from list A to list B.
  """
  @spec distance([], []) :: [{atom, any, non_neg_integer}]
  def distance(source, target) do
    []
  end
end
