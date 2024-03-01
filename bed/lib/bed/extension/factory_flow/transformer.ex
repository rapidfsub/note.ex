defmodule Bed.Extension.FactoryFlow.Transformer do
  use Bed.Prelude.Ash
  use Transformer

  defmodule PrepareInput do
    def build_custom(dsl_state, resource, action) do
      attrs =
        dsl_state
        |> Transformer.get_entities([:factory, :attrs])
        |> Enum.map(&{&1.name, &1.fun})

      action = resource |> Resource.Info.action(action)
      attributes = action.accept |> Enum.map(&Resource.Info.attribute(resource, &1))

      attrs =
        (attributes ++ action.arguments)
        |> Enum.reduce(attrs, fn a, attrs ->
          Keyword.put_new(attrs, a.name, Bed.Extension.FieldFactory.fun(a.type))
        end)

      Transformer.build_entity(
        Flow.Dsl,
        [:steps],
        :custom,
        name: :prepare,
        custom: {PrepareInput, attrs}
      )
    end

    def run(nil, attrs, _context) do
      {:ok, attrs |> Map.new(fn {name, fun} -> {name, fun.()} end)}
    end
  end

  @impl Transformer
  def before?(Ash.Flow.Transformers.SetApi), do: true
  def before?(_), do: false

  @impl Transformer
  def transform(dsl_state) do
    api = dsl_state |> Transformer.get_option([:factory], :api)

    case dsl_state |> Transformer.get_option([:flow], :api) do
      ^api ->
        {:ok, dsl_state}

      _ ->
        resource = dsl_state |> Transformer.get_option([:factory], :resource)
        action = dsl_state |> Transformer.get_option([:factory], :action)

        dsl_state =
          dsl_state
          |> Transformer.set_option([:flow], :api, api)
          |> Transformer.set_option([:flow], :returns, :factory)

        [
          PrepareInput.build_custom(dsl_state, resource, action),
          build_create(resource, action)
        ]
        |> Enum.reduce({:ok, dsl_state}, fn {:ok, step}, {:ok, dsl_state} ->
          {:ok, dsl_state |> Transformer.add_entity([:steps], step)}
        end)
    end
  end

  defp build_create(resource, action) do
    Transformer.build_entity(
      Flow.Dsl,
      [:steps],
      :create,
      name: :factory,
      resource: resource,
      action: action,
      input: StepHelpers.result(:prepare)
    )
  end
end
