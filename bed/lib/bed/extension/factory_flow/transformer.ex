defmodule Bed.Extension.FactoryFlow.Transformer do
  use Bed.Prelude
  use Bed.Prelude.Ash
  use Transformer

  defmodule PrepareInput do
    def build_custom(dsl_state) do
      attrs =
        dsl_state
        |> Transformer.get_entities([:factory, :attrs])
        |> Enum.map(&{&1.name, &1.fun})

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
    factory_api = dsl_state |> Transformer.get_option([:factory], :api)

    case dsl_state |> Transformer.get_option([:flow], :api) do
      ^factory_api ->
        {:ok, dsl_state}

      _ ->
        dsl_state =
          dsl_state
          |> Transformer.set_option([:flow], :api, factory_api)
          |> Transformer.set_option([:flow], :returns, :factory)

        [
          PrepareInput.build_custom(dsl_state),
          build_create(dsl_state)
        ]
        |> Enum.reduce({:ok, dsl_state}, fn {:ok, step}, {:ok, dsl_state} ->
          {:ok, dsl_state |> Transformer.add_entity([:steps], step)}
        end)
    end
  end

  defp build_create(dsl_state) do
    factory_action = dsl_state |> Transformer.get_option([:factory], :action)
    factory_resource = dsl_state |> Transformer.get_option([:factory], :resource)

    Transformer.build_entity(
      Flow.Dsl,
      [:steps],
      :create,
      name: :factory,
      resource: factory_resource,
      action: factory_action,
      input: StepHelpers.result(:prepare)
    )
  end
end
