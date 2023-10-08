defmodule NameBadge do
  def print(id, name, department) do
    department = print_department(department)

    if is_nil(id) do
      [name, department]
    else
      ["[#{id}]", name, department]
    end
    |> Enum.join(" - ")
  end

  defp print_department(nil), do: "OWNER"
  defp print_department(value), do: to_string(value) |> String.upcase()
end
