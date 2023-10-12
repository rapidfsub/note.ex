defmodule RumblWeb.UserHTML do
  alias Rumbl.Accounts

  use RumblWeb, :view

  embed_templates "user_html/*"

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
