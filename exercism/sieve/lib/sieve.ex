defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    sieve(2..limit//1)
  end

  defp sieve(numbers) do
    case Enum.split(numbers, 1) do
      {[], []} -> []
      {[head], tail} -> [head | Enum.filter(tail, &(rem(&1, head) != 0)) |> sieve()]
    end
  end
end
