defmodule AshFactory.ActionFactory.Transformer do
  use Prelude.Ash
  use Transformer

  @impl Transformer
  def transform(dsl_state) do
    attributes = dsl_state |> get_attributes()

    dsl_state
    |> Transformer.get_entities([:factories])
    |> Enum.reduce(dsl_state, fn factory, dsl_state ->
      dsl_state |> add_factory(factory, attributes)
    end)
  end

  defp get_attributes(dsl_state) do
    dsl_state
    |> Transformer.get_entities([:attributes])
    |> Enum.filter(& &1.writable?)
  end

  defbuilderp add_factory(dsl_state, factory, attributes) do
    changes = build_changes(factory, attributes)

    dsl_state
    |> RB.add_new_action(:create, factory.name, accept: [], changes: changes)
    |> RB.add_new_interface(factory.name)
  end

  defp build_changes(factory, attributes) do
    (factory.attributes ++ attributes)
    |> Enum.uniq_by(& &1.name)
    |> Enum.map(&build_change/1)
  end

  defp build_change(%{name: name, type: type}) do
    fun = type |> AshFactory.ActionFactory.Entity.AttributeGenerator.fun()
    %{name: name, fun: fun} |> build_change()
  end

  defp build_change(%{name: name, fun: fun}) do
    {Resource.Change.SetAttribute, attribute: name, value: fun} |> RB.build_change()
  end
end
