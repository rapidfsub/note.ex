defmodule Bed.Model do
  use Ash.Api
  use Bed.Prelude

  resources do
    resource M.BankAccount
    resource M.BankTxn
    resource M.Identity
    resource M.Token
  end
end
