defmodule Bed.Model.Identity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  use Bed.Model.Template

  postgres do
    table "identity"
  end

  attributes do
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  identities do
    identity :unique_email, [:email]
  end

  authentication do
    api Bed.Model

    strategies do
      password :password do
        identity_field :email
        sign_in_tokens_enabled? true
      end
    end

    tokens do
      enabled? true
      token_resource Bed.Model.Token
      signing_secret Bed.Auth.Secrets
    end
  end
end
