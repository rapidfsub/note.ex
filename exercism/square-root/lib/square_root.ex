defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) when 0 < radicand do
    herons_method(1, radicand)
  end

  defp herons_method(result, radicand) when result * result == radicand do
    result
  end

  defp herons_method(result, radicand) do
    round((result + radicand / result) / 2) |> herons_method(radicand)
  end
end
