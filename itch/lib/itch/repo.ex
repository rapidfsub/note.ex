defmodule Itch.Repo do
  use Ecto.Repo,
    otp_app: :itch,
    adapter: Ecto.Adapters.Postgres
end
