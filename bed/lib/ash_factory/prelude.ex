defmodule AshFactory.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias AshFactory.Helper.EnumHelper
    end
  end
end
