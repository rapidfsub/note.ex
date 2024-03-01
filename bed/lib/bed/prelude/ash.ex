defmodule Bed.Prelude.Ash do
  defmacro __using__(_opts) do
    quote do
      alias Ash.{Resource, Flow}
      alias Ash.Resource.Builder, as: RB
      alias Ash.Flow.StepHelpers
      alias Spark.Dsl.{Entity, Extension, Section, Transformer}
    end
  end
end
