defmodule LogLevel do
  def to_label(0, false), do: :trace
  def to_label(1, _legacy?), do: :debug
  def to_label(2, _legacy?), do: :info
  def to_label(3, _legacy?), do: :warning
  def to_label(4, _legacy?), do: :error
  def to_label(5, false), do: :fatal
  def to_label(_level, _legacy?), do: :unknown

  def alert_recipient(level, legacy?) do
    label = to_label(level, legacy?)

    cond do
      label in [:error, :fatal] ->
        :ops

      label == :unknown ->
        if legacy? do
          :dev1
        else
          :dev2
        end

      true ->
        false
    end
  end
end
