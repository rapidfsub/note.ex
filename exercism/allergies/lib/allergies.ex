defmodule Allergies do
  @items ~w[eggs peanuts shellfish strawberries tomatoes chocolate pollen cats]

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    Enum.filter(@items, &allergic_to?(flags, &1))
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    Bitwise.band(score(item), flags) != 0
  end

  defp score("eggs"), do: 1
  defp score("peanuts"), do: 2
  defp score("shellfish"), do: 4
  defp score("strawberries"), do: 8
  defp score("tomatoes"), do: 16
  defp score("chocolate"), do: 32
  defp score("pollen"), do: 64
  defp score("cats"), do: 128
end
