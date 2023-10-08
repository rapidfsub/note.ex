defmodule Username do
  def sanitize(username) do
    Enum.flat_map(username, &do_sanitize/1)
  end

  defp do_sanitize(letter) do
    case letter do
      letter when letter in ?a..?z or letter == ?_ -> [letter]
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
      _ -> []
    end
  end
end
