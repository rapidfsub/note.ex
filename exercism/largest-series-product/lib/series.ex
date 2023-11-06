defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(number_string, size) when size > 0 do
    number_string
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Stream.unfold(fn
      [] -> nil
      [_ | next] = curr -> {Stream.take(curr, size), next}
    end)
    |> Stream.drop(1 - size)
    |> Stream.map(&Enum.product/1)
    |> Enum.max(fn -> raise ArgumentError end)
  end

  def largest_product(_number_string, _size) do
    raise ArgumentError
  end
end
