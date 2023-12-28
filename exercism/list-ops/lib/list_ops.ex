defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: count(l, 0)
  defp count([], result), do: result
  defp count([_ | tail], result), do: count(tail, result + 1)

  @spec reverse(list) :: list
  def reverse(l), do: reverse(l, [])
  defp reverse([], result), do: result
  defp reverse([head | tail], result), do: reverse(tail, [head | result])

  @spec map(list, (any -> any)) :: list
  def map([], _f), do: []
  def map([head | tail], f), do: [f.(head) | map(tail, f)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], _f) do
    []
  end

  def filter([head | tail], f) do
    if f.(head) do
      [head | filter(tail, f)]
    else
      filter(tail, f)
    end
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _f), do: acc
  def foldl([head | tail], acc, f), do: foldl(tail, f.(head, acc), f)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr([], acc, _f), do: acc
  def foldr([head | tail], acc, f), do: f.(head, foldr(tail, acc, f))

  @spec append(list, list) :: list
  def append(a, b), do: concat([a, b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: concat(ll, [])
  defp concat([], result), do: reverse(result)
  defp concat([[] | ll], result), do: concat(ll, result)
  defp concat([[head | tail] | ll], result), do: concat([tail | ll], [head | result])
end
