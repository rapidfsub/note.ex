defmodule RumblWeb.UserHTML do
  alias Rumbl.Accounts
  alias RumblWeb.Router.Helpers, as: Routes

  import Phoenix.HTML.Link

  use RumblWeb, :html

  embed_templates "user_html/*"

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
