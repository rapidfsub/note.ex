defmodule Dot do
  defmacro graph(do: ast) do
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

  defp do_graph({id, _, nil}, acc) do
    {:node, Graph.add_node(acc, id)}
  end

  defp do_graph({id, _, [attrs]}, acc) when is_list(attrs) do
    {:node, Graph.add_node(acc, id, attrs)}
  end

  defp do_graph(ast, acc) when is_tuple(ast) do
    {ast, acc}
  end

  defp do_graph(_ast, _acc) do
    raise ArgumentError
  end
end
