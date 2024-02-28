defmodule Bed.Repo do
  use AshPostgres.Repo,
    otp_app: :bed

  # Installs Postgres extensions that ash commonly uses
  def installed_extensions do
    ~w[citext uuid-ossp]
  end
end
