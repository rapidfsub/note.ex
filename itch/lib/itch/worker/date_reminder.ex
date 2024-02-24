defmodule Itch.Worker.DateReminder do
  use Oban.Worker

  @impl Oban.Worker
  def perform(_job) do
    Date.utc_today()
    |> Date.convert!(Cldr.Calendar.Korean)
    |> inspect()
    |> Itch.Slack.webhook()

    :ok
  end
end
