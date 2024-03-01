defmodule AshFactory.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias AshFactory.Target, as: T
    end
  end
end
