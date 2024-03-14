defmodule BirdCount do
  def today(list) do
    list |> Enum.at(0)
  end

  def increment_day_count([]), do: [1]
  def increment_day_count([head | tail]), do: [head + 1 | tail]

  def has_day_without_birds?(list) do
    list |> Enum.member?(0)
  end

  def total(list) do
    list |> Enum.sum()
  end

  def busy_days(list) do
    list |> Enum.count(&(5 <= &1))
  end
end
