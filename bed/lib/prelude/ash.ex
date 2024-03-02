defmodule Prelude.Ash do
  defmacro __using__(_opts) do
    quote do
      alias Ash.{Api, Flow, Resource}
      alias Ash.Resource.Builder, as: RB
      alias Ash.Flow.StepHelpers
      alias Spark.Dsl.{Entity, Extension, Section, Transformer, Verifier}

      use Spark.Dsl.Builder
    end
  end
end
