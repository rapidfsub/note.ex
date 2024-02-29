defmodule Bed.Sigil do
  def sigil_d(term, []) do
    Decimal.new(term)
  end
end
