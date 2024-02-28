defmodule Bed.Model do
  use Ash.Api

  resources do
    resource Bed.Model.Identity
    resource Bed.Model.Token
  end
end
