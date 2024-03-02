defmodule Bed.Model.BankAccount do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  use Bed.Prelude
  use M.Template

  postgres do
    table "bank_account"
  end

  attributes do
    attribute :nickname, :string, allow_nil?: false
    attribute :balance, :decimal, allow_nil?: false
  end

  relationships do
    belongs_to :identity, M.Identity
    has_many :bank_txns, M.BankTxn
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
end
