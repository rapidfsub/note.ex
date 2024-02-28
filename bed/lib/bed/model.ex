defmodule Bed.Model do
  use Ash.Api

  resources do
    resource Bed.Model.Identity
  end
end
