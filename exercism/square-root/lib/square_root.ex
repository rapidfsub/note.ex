defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) when 0 < radicand do
    calculate(radicand, 1, radicand)
  end

  defp calculate(radicand, lower, upper) do
    result = (lower + upper) / 2

    cond do
      result * result == radicand -> result
      result * result > radicand -> calculate(radicand, lower, result)
      result * result < radicand -> calculate(radicand, result, upper)
    end
  end
end
