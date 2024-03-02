defmodule AshFactory.Helper.EnumHelper do
  def sequence(enumerable, fun) do
    enumerable
    |> Enum.map(fun)
    |> Enum.reduce_while({:ok, []}, fn
      {:ok, x}, {:ok, acc} -> {:cont, {:ok, [x | acc]}}
      {:error, x}, _acc -> {:halt, {:error, x}}
    end)
    |> case do
      {:ok, acc} -> {:ok, acc |> Enum.reverse()}
      error -> error
    end
  end
end
