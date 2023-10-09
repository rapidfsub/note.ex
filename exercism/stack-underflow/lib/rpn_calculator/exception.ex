defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    def exception(context) when is_binary(context) do
      %__MODULE__{message: "stack underflow occurred, context: #{context}"}
    end

    def exception([]) do
      %__MODULE__{}
    end
  end

  def divide([0, _dividend]) do
    raise DivisionByZeroError
  end

  def divide([divisor, dividend]) do
    div(dividend, divisor)
  end

  def divide([_]) do
    raise StackUnderflowError, "when dividing"
  end

  def divide([]) do
    raise StackUnderflowError, "when dividing"
  end
end
