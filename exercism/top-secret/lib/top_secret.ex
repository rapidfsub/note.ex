defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part({value, _, nodes} = ast, acc) when value in [:def, :defp] do
    {ast, [function_secret_message(nodes) | acc]}
  end

  def decode_secret_message_part(ast, acc) do
    {ast, acc}
  end

  defp function_secret_message([{:when, _, nodes} | _]) do
    function_secret_message(nodes)
  end

  defp function_secret_message([{name, _, args} | _]) do
    name
    |> to_string()
    |> binary_part(0, length(args || []))
  end

  def decode_secret_message(string) do
    {_ast, acc} = Macro.prewalk(to_ast(string), [], &decode_secret_message_part/2)
    Enum.reverse(acc) |> to_string()
  end
end
