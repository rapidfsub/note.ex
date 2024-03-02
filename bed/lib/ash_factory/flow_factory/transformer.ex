# defmodule AshFactory.FlowFactory.Transformer do
#   use AshFactory.Prelude
#   use Prelude.Ash
#   use Transformer

#   @impl Transformer
#   def transform(dsl_state) do
#     api = dsl_state |> Transformer.get_option([:factory], :api)
#     resource = dsl_state |> Transformer.get_option([:factory], :resource)
#     action = dsl_state |> Transformer.get_option([:factory], :action)
#     dsl_state = dsl_state |> Transformer.set_option([:flow], :returns, :factory)

#     [
#       build_prepare_step!(dsl_state, :prepare, resource, action),
#       build_factory_step!(api, resource, action, :prepare)
#     ]
#     |> Enum.reduce({:ok, dsl_state}, fn step, {:ok, dsl_state} ->
#       {:ok, dsl_state |> Transformer.add_entity([:steps], step)}
#     end)
#   end

#   def run(nil, attrs, _context) do
#     {:ok, attrs |> Map.new(fn {name, fun} -> {name, fun.()} end)}
#   end

#   defp build_prepare_step!(dsl_state, name, resource, action) do
#     factory_attrs = dsl_state |> Transformer.get_entities([:factory, :attrs])
#     action = resource |> Resource.Info.action(action)
#     attributes = resource |> get_attributes(action)
#     funs = get_run_options(attributes, action.arguments, factory_attrs)

#     Transformer.build_entity!(Flow.Dsl, [:steps], :custom,
#       name: name,
#       custom: {__MODULE__, funs}
#     )
#   end

#   defp get_attributes(resource, action) do
#     action.accept
#     |> Enum.map(&Resource.Info.attribute(resource, &1))
#     |> Enum.filter(fn a ->
#       a.writable? and a.name not in action.reject
#     end)
#   end

#   defp get_run_options(attributes, arguments, factory_attrs) do
#     factory_attrs
#     |> Enum.concat(attributes)
#     |> Enum.concat(arguments)
#     |> Enum.uniq_by(& &1.name)
#     |> Enum.map(fn
#       %{name: name, type: type} -> {name, T.FieldFactory.fun(type)}
#       %{name: name, fun: fun} -> {name, fun}
#     end)
#   end

#   defp build_factory_step!(api, resource, action, input_name) do
#     Transformer.build_entity!(Flow.Dsl, [:steps], :create,
#       name: :factory,
#       api: api,
#       resource: resource,
#       action: action,
#       input: StepHelpers.result(input_name)
#     )
#   end
# end
