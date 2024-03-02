defmodule AshFactory.ActionFactory.Transformer do
  use Prelude.Ash
  use Transformer

  @impl Transformer
  def transform(dsl_state) do
    attributes = dsl_state |> get_attributes()
    relationships = dsl_state |> get_relationships()

    dsl_state
    |> Transformer.get_entities([:factories])
    |> Enum.reduce({:ok, dsl_state}, fn factory, dsl_state ->
      dsl_state |> add_factory(factory, attributes, relationships)
    end)
  end

  defp get_attributes(dsl_state) do
    dsl_state
    |> Transformer.get_entities([:attributes])
    |> Enum.filter(& &1.writable?)
  end

  defp get_relationships(dsl_state) do
    dsl_state
    |> Transformer.get_entities([:relationships])
    |> Enum.filter(fn r ->
      is_struct(r, Resource.Relationships.BelongsTo)
    end)
    |> Enum.filter(& &1.writable?)
  end

  defbuilderp add_factory(dsl_state, factory, attributes, relationships) do
    arguments = build_arguments(relationships)
    changes = build_changes(factory, attributes, relationships)

    dsl_state
    |> RB.add_new_action(:create, factory.name,
      accept: [],
      arguments: arguments,
      changes: changes
    )
    |> RB.add_new_interface(factory.name)
  end

  defp build_arguments(relationships) do
    relationships
    |> Enum.uniq_by(& &1.name)
    |> Enum.map(fn r ->
      RB.build_action_argument(r.name, :map, private?: true, default: %{})
    end)
  end

  defp build_changes(factory, attributes, relationships) do
    (factory.attributes ++ attributes ++ relationships)
    |> Enum.uniq_by(& &1.name)
    |> Enum.map(&build_change/1)
  end

  defp build_change(%Resource.Attribute{name: name, type: type}) do
    fun = type |> AshFactory.ActionFactory.Entity.AttributeGenerator.fun()
    %{name: name, fun: fun} |> build_change()
  end

  defp build_change(%{name: name, fun: fun}) do
    {Change.SetAttribute, attribute: name, value: fun}
    |> RB.build_change()
  end

  defp build_change(%Resource.Relationships.BelongsTo{name: name, destination: destination}) do
    factory = destination.entities([:factories]) |> hd()

    {Change.ManageRelationship,
     relationship: name, argument: name, opts: [on_no_match: {:create, factory.name}]}
    |> RB.build_change()
  end
end
