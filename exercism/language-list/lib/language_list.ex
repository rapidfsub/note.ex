defmodule LanguageList do
  def new() do
    []
  end

  def add(list, language) do
    [language | list]
  end

  def remove([_ | result]) do
    result
  end

  def first([result | _]) do
    result
  end

  def count([]), do: 0
  def count([_ | tail]), do: 1 + count(tail)

  def functional_list?([]), do: false
  def functional_list?(["Elixir" | _]), do: true
  def functional_list?([_ | tail]), do: functional_list?(tail)
end
