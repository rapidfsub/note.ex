defmodule Bed.Extension.Factory.Transformer do
  alias Ash.Resource.Builder, as: RB
  alias Spark.Dsl.Transformer
  use Spark.Dsl.Transformer

  @impl Spark.Dsl.Transformer
  def transform(dsl_state) do
    dsl_state
    |> Transformer.get_entities([:factories])
    |> Enum.reduce({:ok, dsl_state}, fn factory, {:ok, dsl_state} ->
      changes =
        factory.attrs
        |> Enum.map(fn attr ->
          RB.build_change(
            {Ash.Resource.Change.SetAttribute, attribute: attr.name, value: attr.fun}
          )
        end)

      dsl_state
      |> RB.add_new_action(:create, factory.name, accept: [], changes: changes)
      |> RB.add_new_interface(factory.name)
    end)
  end
end
