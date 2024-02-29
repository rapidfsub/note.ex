defmodule Bed.Prelude.Ash do
  defmacro __using__(_opts) do
    quote do
      alias Ash.Resource.Builder, as: RB
      alias Spark.Dsl.{Entity, Section, Transformer}
    end
  end
end
