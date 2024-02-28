defmodule BedWeb.Router do
  use AshAuthentication.Phoenix.Router
  use Bed.Prelude
  use BedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BedWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :session_users do
    plug :load_from_session
  end

  pipeline :bearer_users do
    plug :load_from_bearer
  end

  scope "/", BedWeb do
    pipe_through [:browser, :session_users]

    get "/", PageController, :home
  end

  scope "/", BedWeb do
    pipe_through :browser

    sign_in_route(register_path: "/register", reset_path: "/reset")
    sign_out_route AuthController
    auth_routes_for M.Identity, to: AuthController
    reset_route []
  end

  # Other scopes may use custom stacks.
  # scope "/api", BedWeb do
  #   pipe_through [:api, :bearer_users]
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bed, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BedWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
