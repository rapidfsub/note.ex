defmodule Bed.Model.BankTxn do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  use Bed.Prelude
  use M.Template

  postgres do
    table "bank_txn"
  end

  attributes do
    attribute :amount, :decimal, allow_nil?: false
  end

  relationships do
    belongs_to :bank_account, M.BankAccount
  end
end
