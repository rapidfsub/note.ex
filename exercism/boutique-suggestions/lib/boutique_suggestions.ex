defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ []) do
    maximum_price = Keyword.get(options, :maximum_price, 100)

    for %{base_color: c1, price: p1} = top <- tops,
        %{base_color: c2, price: p2} = bottom <- bottoms,
        c1 != c2 and p1 + p2 <= maximum_price do
      {top, bottom}
    end
  end
end
