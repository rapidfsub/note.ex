defmodule Alan.Model do
  use Ash.Api

  resources do
    resource Alan.Model.Post
  end
end
