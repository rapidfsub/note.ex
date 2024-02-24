defmodule Itch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Oban.Telemetry.attach_default_logger()

    children = [
      ItchWeb.Telemetry,
      Itch.Repo,
      {DNSCluster, query: Application.get_env(:itch, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Itch.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Itch.Finch},
      # Start a worker by calling: Itch.Worker.start_link(arg)
      # {Itch.Worker, arg},
      # Start to serve requests, typically the last entry
      ItchWeb.Endpoint,
      {Oban, Application.fetch_env!(:itch, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Itch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ItchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
