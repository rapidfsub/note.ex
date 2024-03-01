defmodule AshFactory.ActionFactories.Transformer do
  use AshFactory.Prelude
  use Prelude.Ash
  use Transformer

  @impl Transformer
  def transform(dsl_state) do
    dsl_state
    |> Transformer.get_entities([:factories])
    |> Enum.reduce({:ok, dsl_state}, fn factory, {:ok, dsl_state} ->
      attrs = factory.attrs |> Enum.map(fn attr -> {attr.name, attr.fun} end)

      attrs =
        dsl_state
        |> Transformer.get_entities([:attributes])
        |> Enum.filter(& &1.writable?)
        |> Enum.reduce(attrs, fn a, attrs ->
          Keyword.put_new(attrs, a.name, T.FieldFactory.fun(a.type))
        end)

      changes =
        attrs
        |> Enum.map(fn {name, fun} ->
          RB.build_change({Resource.Change.SetAttribute, attribute: name, value: fun})
        end)

      dsl_state
      |> RB.add_new_action(:create, factory.name, accept: [], changes: changes)
      |> RB.add_new_interface(factory.name)
    end)
  end
end
