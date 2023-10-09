defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    %{pid: spawn_link(fn -> calculator.(input) end), input: input}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, _reason} -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(calculator, inputs) do
    inputs
    |> Enum.map(fn input ->
      Task.async(fn ->
        Process.flag(:trap_exit, true)

        calculator
        |> start_reliability_check(input)
        |> await_reliability_check_result(%{})
        |> Enum.fetch!(0)
      end)
    end)
    |> Task.await_many()
    |> Enum.into(%{})
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Task.await_many(100)
  end
end
