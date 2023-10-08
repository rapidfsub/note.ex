defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    path
    |> keys()
    |> Enum.reduce_while(data, fn key, data ->
      case data[key] do
        nil -> {:halt, nil}
        data -> {:cont, data}
      end
    end)
  end

  defp keys(path) do
    String.split(path, ".")
  end

  def get_in_path(data, path) do
    get_in(data, keys(path))
  end
end
