defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    letters = Regex.replace(~r/\s+/, number, "")

    Regex.match?(~r/^\d+$/, letters) and
      1 < byte_size(letters) and
      letters
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {digit, index} ->
        if rem(index, 2) == 0 or digit == 9 do
          digit
        else
          rem(digit * 2, 9)
        end
      end)
      |> Enum.sum()
      |> rem(10) == 0
  end
end
