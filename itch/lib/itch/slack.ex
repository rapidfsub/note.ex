defmodule Itch.Slack do
  def webhook(text) do
    endpoint() |> Req.post!(json: %{text: text})
  end

  defp endpoint do
    Application.fetch_env!(:itch, :slack_webhook)
  end
end
