defmodule Bed.Model.Identity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshAuthentication,
      Bed.Extension.Factory
    ]

  use Bed.Prelude
  use M.Template

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

  relationships do
    has_many :accounts, M.Account
  end

  authentication do
    api Bed.Model

    strategies do
      password :password do
        identity_field :email
        sign_in_tokens_enabled? true

        resettable do
          sender Bed.Auth.SendPasswordResetEmail
        end
      end
    end

    tokens do
      enabled? true
      token_resource M.Token
      signing_secret Bed.Auth.Secrets
    end
  end
end
