defmodule Bed.Model do
  use Ash.Api
  use Bed.Prelude

  resources do
    resource M.Account
    resource M.Identity
    resource M.Token
  end
end
