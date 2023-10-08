defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part({value, _, nodes} = ast, acc) when value in [:def, :defp] do
    {name, args} =
      case nodes do
        [{:when, _, [{name, _, args} | _]} | _] -> {name, args}
        [{name, _, args} | _] -> {name, args}
      end

    name = to_string(name)
    arity = length(args || [])
    {ast, [binary_part(name, 0, arity) | acc]}
  end

  def decode_secret_message_part(ast, acc) do
    {ast, acc}
  end

  def decode_secret_message(string) do
    {_ast, acc} = Macro.prewalk(to_ast(string), [], &decode_secret_message_part/2)
    Enum.reverse(acc) |> to_string()
  end
end
