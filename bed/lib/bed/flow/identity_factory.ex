defmodule Bed.Flow.IdentityFactory do
  use Ash.Flow,
    extensions: [AshFactory.FlowFactory]

  use Bed.Prelude

  factory do
    api M
    resource M.Identity
    action :register_with_password

    attrs do
      attr :password, fn -> "password" end
      attr :password_confirmation, fn -> "password" end
    end
  end
end
