defmodule Alan.Repo do
  use AshPostgres.Repo,
    otp_app: :alan

  # Installs Postgres extensions that ash commonly uses
  def installed_extensions do
    ~w[ash-functions uuid-ossp pg_trgm citext]
  end
end
