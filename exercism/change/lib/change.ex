defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    coins
    |> Enum.sort(:desc)
    |> do_generate(target, [], 0, nil)
    |> case do
      {:ok, result, _step} -> {:ok, result}
      {:error, _reason} = error -> error
    end
  end

  defp do_generate([ch | ct] = coins, target, acc, len, lim)
       when target > 0 and (is_nil(lim) or len < lim) do
    case do_generate(coins, target - ch, [ch | acc], len + 1, lim) do
      {:ok, _result, next_lim} = lhs ->
        with {:error, _reason} <- do_generate(ct, target, acc, len, next_lim) do
          lhs
        end

      {:error, _reason} ->
        do_generate(ct, target, acc, len, lim)
    end
  end

  defp do_generate(_coins, 0, acc, len, lim) when is_nil(lim) or len < lim do
    {:ok, acc, len}
  end

  defp do_generate(_coins, _target, _acc, _len, _lim) do
    {:error, "cannot change"}
  end
end
