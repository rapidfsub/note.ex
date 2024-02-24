defmodule Itch.Repo do
  use AshPostgres.Repo,otp_app: :itch

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
