defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(dimension) when 0 < dimension do
    [did_visit] =
      Stream.unfold({1, {0, 0}, {0, 1}, %{}}, fn
        nil ->
          nil

        {i, pos, dir, did_visit} ->
          did_visit = Map.put(did_visit, pos, i)

          case next_position(pos, dir, dimension, did_visit) do
            nil ->
              dir = rotate(dir)

              case next_position(pos, dir, dimension, did_visit) do
                nil -> {did_visit, nil}
                pos -> {did_visit, {i + 1, pos, dir, did_visit}}
              end

            pos ->
              {did_visit, {i + 1, pos, dir, did_visit}}
          end
      end)
      |> Enum.take(-1)

    for i <- 0..(dimension - 1) do
      for j <- 0..(dimension - 1) do
        Map.fetch!(did_visit, {i, j})
      end
    end
  end

  def matrix(_dimension) do
    []
  end

  defp next_position({row, col}, {rd, cd}, dimension, did_visit) do
    {r, c} = position = {row + rd, col + cd}
    range = 0..(dimension - 1)

    if r in range and c in range and not Map.has_key?(did_visit, position) do
      position
    end
  end

  defp rotate({0, 1}), do: {1, 0}
  defp rotate({1, 0}), do: {0, -1}
  defp rotate({0, -1}), do: {-1, 0}
  defp rotate({-1, 0}), do: {0, 1}
end
