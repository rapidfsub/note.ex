defmodule Alan.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias Alan.Model, as: M
    end
  end
end
