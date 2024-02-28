defmodule Bed.Repo do
  use Ecto.Repo,
    otp_app: :bed,
    adapter: Ecto.Adapters.Postgres
end
