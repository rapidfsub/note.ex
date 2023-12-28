defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    composites =
      Enum.reduce(2..limit//1, MapSet.new(), fn x, acc ->
        if MapSet.member?(acc, x) do
          acc
        else
          Enum.reduce((x * 2)..limit//x, acc, fn y, acc ->
            MapSet.put(acc, y)
          end)
        end
      end)

    for number <- 2..limit//1, !MapSet.member?(composites, number) do
      number
    end
  end
end
