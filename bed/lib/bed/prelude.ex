defmodule Bed.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias Bed.Model, as: M
      import Bed.Sigil, only: :functions
    end
  end
end