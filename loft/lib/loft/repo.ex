defmodule Loft.Repo do
  use Ecto.Repo,
    otp_app: :loft,
    adapter: Ecto.Adapters.Postgres
end
