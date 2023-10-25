defmodule Dot do
  defmacro graph(ast) do
    Macro.prewalk(ast, quote(do: Graph.new()), &do_graph/2) |> elem(1)
  end

  defp do_graph({:graph, _, [attrs]}, acc) when is_list(attrs) do
    {:graph, quote(do: Graph.put_attrs(unquote(acc), unquote(attrs)))}
  end

  defp do_graph({:--, _, [{from, _, nil}, {to, _, nil}]}, acc) do
    {:edge, quote(do: Graph.add_edge(unquote(acc), unquote(from), unquote(to)))}
  end

  defp do_graph({:--, _, [{from, _, nil}, {to, _, [attrs]}]}, acc) when is_list(attrs) do
    {:edge, quote(do: Graph.add_edge(unquote(acc), unquote(from), unquote(to), unquote(attrs)))}
  end

  defp do_graph([do: _] = ast, acc) do
    {ast, acc}
  end

  defp do_graph({:__block, _, _} = ast, acc) do
    {ast, acc}
  end

  defp do_graph({id, _, nil} = ast, acc) do
    {ast, quote(do: Graph.add_node(unquote(acc), unquote(id)))}
  end

  defp do_graph({id, _, [attrs]}, acc) do
    if Keyword.keyword?(attrs) do
      {:node, quote(do: Graph.add_node(unquote(acc), unquote(id), unquote(attrs)))}
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
