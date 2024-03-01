defmodule Bed.Model.Account do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [Bed.Extension.Factory]

  use Bed.Prelude
  use M.Template

  postgres do
    table "account"
  end

  attributes do
    attribute :nickname, :string, allow_nil?: false
    attribute :balance, :decimal, allow_nil?: false
  end

  relationships do
    belongs_to :identity, M.Identity
  end

  actions do
    create :open do
      reject [:balance]
      change set_attribute(:balance, 0)
    end
  end

  code_interface do
    define :open
  end

  factories do
    factory :gen do
    end
  end
end
