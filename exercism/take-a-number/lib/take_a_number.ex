defmodule TakeANumber do
  def start() do
    spawn(fn -> do_start(0) end)
  end

  defp do_start(state) do
    receive do
      {:report_state, pid} ->
        send(pid, state)
        do_start(state)

      {:take_a_number, pid} ->
        state = state + 1
        send(pid, state)
        do_start(state)

      :stop ->
        nil

      _ ->
        do_start(state)
    end
  end
end
