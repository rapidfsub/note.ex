defmodule Dot do
  defmacro graph(ast) do
    ast
    |> Macro.prewalk(Graph.new(), &do_graph/2)
    |> elem(1)
    |> Macro.escape()
  end

  defp do_graph({:graph, _, [attrs]}, acc) when is_list(attrs) do
    {:graph, Graph.put_attrs(acc, attrs)}
  end

  defp do_graph({:--, _, [{from, _, nil}, {to, _, nil}]}, acc) do
    {:edge, Graph.add_edge(acc, from, to)}
  end

  defp do_graph({:--, _, [{from, _, nil}, {to, _, [attrs]}]}, acc) when is_list(attrs) do
    {:edge, Graph.add_edge(acc, from, to, attrs)}
  end

  defp do_graph([do: _] = ast, acc) do
    {ast, acc}
  end

  defp do_graph({:__block, _, _} = ast, acc) do
    {ast, acc}
  end

  defp do_graph({id, _, nil} = ast, acc) do
    {ast, Graph.add_node(acc, id)}
  end

  defp do_graph({id, _, [attrs]}, acc) do
    if Keyword.keyword?(attrs) do
      {:node, Graph.add_node(acc, id, attrs)}
    else
      raise ArgumentError
    end
  end

  defp do_graph(ast, _acc) when is_integer(ast) or is_list(ast) do
    raise ArgumentError
  end

  defp do_graph(ast, acc) do
    {ast, acc}
  end
end
