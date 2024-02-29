defmodule Bed.Auth.Secrets do
  use AshAuthentication.Secret
  use Bed.Prelude

  def secret_for([:authentication, :tokens, :signing_secret], M.Identity, _) do
    case Application.fetch_env(:bed, BedWeb.Endpoint) do
      {:ok, endpoint_config} ->
        Keyword.fetch(endpoint_config, :secret_key_base)

      :error ->
        :error
    end
  end
end
