defmodule AshFactory.ActionFactory.Verifiers.NoPrimaryDuplicates do
  use Prelude.Ash
  use Verifier

  @impl Verifier
  def verify(dsl_state) do
    dsl_state
    |> Verifier.get_entities([:factories])
    |> Enum.filter(& &1.primary?)
    |> case do
      [_, _ | _] ->
        {:error,
         {"Multiple primary factories found",
          module: dsl_state |> Verifier.get_persisted(:module)}}

      _ ->
        :ok
    end
  end
end
