defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Stream.chunk_every(workers)
    |> Stream.flat_map(fn texts ->
      texts
      |> Enum.map(&Task.async(fn -> frequency(&1) end))
      |> Task.await_many()
    end)
    |> Enum.reduce(%{}, fn map, acc ->
      Map.merge(acc, map, fn _key, v1, v2 -> v1 + v2 end)
    end)
  end

  defp frequency(text) do
    text
    |> String.replace(~r/[^\pL]/u, "")
    |> String.downcase()
    |> String.graphemes()
    |> Enum.frequencies()
  end
end
