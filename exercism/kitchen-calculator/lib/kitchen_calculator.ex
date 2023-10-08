defmodule KitchenCalculator do
  @units ~w[cup fluid_ounce teaspoon tablespoon milliliter]a

  def get_volume({unit, volume}) when unit in @units do
    volume
  end

  defp conversion_factor(:milliliter), do: 1
  defp conversion_factor(:cup), do: 240
  defp conversion_factor(:fluid_ounce), do: 30
  defp conversion_factor(:teaspoon), do: 5
  defp conversion_factor(:tablespoon), do: 15

  def to_milliliter({unit, volume}) do
    {:milliliter, volume * conversion_factor(unit)}
  end

  def from_milliliter({:milliliter, volume}, unit) do
    {unit, volume / conversion_factor(unit)}
  end

  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter()
    |> from_milliliter(unit)
  end
end
