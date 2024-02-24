defmodule Itch.Api do
  use Ash.Api

  resources do
    resource Itch.Resource.Anniversary
  end
end
