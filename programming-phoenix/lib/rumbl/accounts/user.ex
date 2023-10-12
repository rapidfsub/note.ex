defmodule Rumbl.Accounts.User do
  import Ecto.Changeset

  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :username, :string

    timestamps()
  end
end
