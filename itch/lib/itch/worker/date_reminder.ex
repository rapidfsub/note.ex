defmodule Itch.Worker.DateReminder do
  use Oban.Worker

  @impl Oban.Worker
  def perform(_job) do
    today = Date.utc_today()
    m1 = Itch.Resource.Anniversary.list_by_type!(:gregorian) |> message(today)
    lunar_today = today |> Date.convert!(Cldr.Calendar.Korean)
    m2 = Itch.Resource.Anniversary.list_by_type!(:lunisolar) |> message(lunar_today)

    [m1, m2]
    |> List.flatten()
    |> Enum.join("\n")
    |> Itch.Slack.webhook()

    :ok
  end

  defp message(anniversaries, today) do
    [
      "날짜: #{today}",
      for a <- anniversaries, a.month == today.month and a.day == today.day do
        "- #{a.name}"
      end
    ]
  end
end
