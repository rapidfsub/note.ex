defmodule Bed.Auth.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
  """
  use AshAuthentication.Sender
  use BedWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user, token, _) do
    Bed.Auth.Emails.deliver_reset_password_instructions(
      user,
      url(~p"/password-reset/#{token}")
    )
  end
end
