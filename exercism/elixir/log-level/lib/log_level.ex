defmodule LogLevel do
  def to_label(level, legacy?)
  def to_label(0, false), do: :trace
  def to_label(1, _legacy), do: :debug
  def to_label(2, _legacy), do: :info
  def to_label(3, _legacy), do: :warning
  def to_label(4, _legacy), do: :error
  def to_label(5, false), do: :fatal
  def to_label(_level, _legacy?), do: :unknown

  def alert_recipient(level, legacy?) do
    level |> to_label(legacy?) |> do_alert_recipient(legacy?)
  end

  defp do_alert_recipient(label, legacy?)
  defp do_alert_recipient(:error, _legacy?), do: :ops
  defp do_alert_recipient(:fatal, _legacy?), do: :ops
  defp do_alert_recipient(:unknown, true), do: :dev1
  defp do_alert_recipient(:unknown, false), do: :dev2
  defp do_alert_recipient(_label, _legacy?), do: false
end
