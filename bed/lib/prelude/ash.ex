defmodule Prelude.Ash do
  defmacro __using__(_opts) do
    quote do
      alias Ash.{Api, Changeset, Flow, Resource}
      alias Ash.Resource.Change
      alias Ash.Flow.StepHelpers
      alias Spark.Dsl.{Entity, Extension, Section, Transformer, Verifier}

      alias Ash.Resource.Builder, as: RB

      use Spark.Dsl.Builder
    end
  end
end
