defmodule RumblWeb.UserController do
  alias Rumbl.Accounts

  use RumblWeb, :controller

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end
end
