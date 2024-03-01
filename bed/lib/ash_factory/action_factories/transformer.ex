defmodule AshFactory.ActionFactories.Transformer do
  use AshFactory.Prelude
  use Prelude.Ash
  use Transformer

  @impl Transformer
  def transform(dsl_state) do
    attributes = dsl_state |> get_attributes()

    dsl_state
    |> Transformer.get_entities([:factories])
    |> Enum.reduce({:ok, dsl_state}, fn factory, {:ok, dsl_state} ->
      dsl_state |> add_factory(factory, attributes)
    end)
  end

  defp get_attributes(dsl_state) do
    dsl_state
    |> Transformer.get_entities([:attributes])
    |> Enum.filter(& &1.writable?)
  end

  defp add_factory(dsl_state, factory, attributes) do
    changes = get_changes(attributes, factory.attrs)

    dsl_state
    |> RB.add_new_action(:create, factory.name, accept: [], changes: changes)
    |> RB.add_new_interface(factory.name)
  end

  defp get_changes(attributes, factory_attrs) do
    factory_attrs
    |> Enum.concat(attributes)
    |> Enum.uniq_by(& &1.name)
    |> Enum.map(&get_change/1)
  end

  defp get_change(%Resource.Attribute{name: name, type: type}) do
    get_change(%{name: name, fun: T.FieldFactory.fun(type)})
  end

  defp get_change(%{name: name, fun: fun}) do
    RB.build_change({Resource.Change.SetAttribute, attribute: name, value: fun})
  end
end
