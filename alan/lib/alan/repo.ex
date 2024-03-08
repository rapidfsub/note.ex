defmodule Alan.Repo do
  use Ecto.Repo,
    otp_app: :alan,
    adapter: Ecto.Adapters.Postgres
end
