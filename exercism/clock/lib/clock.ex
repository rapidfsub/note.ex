defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: %Clock{}
  def new(hour, minute) do
    {carry, minute} = div_mod(minute, 60)
    {_carry, hour} = div_mod(hour + carry, 24)
    %Clock{hour: hour, minute: minute}
  end

  defp div_mod(divisor, dividend) do
    division = div(divisor, dividend)

    case rem(divisor, dividend) do
      modulo when modulo < 0 -> {division - 1, modulo + dividend}
      modulo -> {division, modulo}
    end
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(%Clock{}, integer) :: %Clock{}
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end

  defimpl String.Chars do
    import Kernel, except: [to_string: 1]

    def to_string(%Clock{hour: hour, minute: minute}) do
      "#{String.pad_leading(Kernel.to_string(hour), 2, "0")}:#{String.pad_leading(Kernel.to_string(minute), 2, "0")}"
    end
  end
end
