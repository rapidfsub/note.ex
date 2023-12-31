defmodule Mastery.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias Mastery.Boundary.QuizManager

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Mastery.Worker.start_link(arg)
      # {Mastery.Worker, arg}
      {QuizManager, [name: QuizManager]},
      {Registry, [name: Mastery.Registry.QuizSession, keys: :unique]},
      {DynamicSupervisor, [name: Mastery.Supervisor.QuizSession, strategy: :one_for_one]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mastery.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
