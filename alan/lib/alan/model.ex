defmodule Alan.Model do
  use Alan.Prelude
  use Ash.Api

  resources do
    resource M.Comment
    resource M.Post
  end
end
