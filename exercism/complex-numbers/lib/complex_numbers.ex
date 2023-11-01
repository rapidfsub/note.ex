defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real({real, _imag}) do
    real
  end

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary({_real, imag}) do
    imag
  end

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul(a, b) do
    {real_a, imag_a} = to_complex(a)
    {real_b, imag_b} = to_complex(b)
    {real_a * real_b - imag_a * imag_b, real_a * imag_b + real_b * imag_a}
  end

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add(a, b) do
    {real_a, imag_a} = to_complex(a)
    {real_b, imag_b} = to_complex(b)
    {real_a + real_b, imag_a + imag_b}
  end

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub(a, b) do
    mul(b, -1.0) |> add(a)
  end

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div(a, b) do
    {real_b, imag_b} = b = to_complex(b)

    b
    |> conjugate()
    |> mul(a)
    |> mul(1 / (real_b ** 2 + imag_b ** 2))
  end

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs({real, imag}) do
    :math.sqrt(real ** 2 + imag ** 2)
  end

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({real, imag}) do
    {real, -imag}
  end

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({real, imag}) do
    :math.exp(real) |> mul({:math.cos(imag), :math.sin(imag)})
  end

  defp to_complex(a) when is_number(a), do: {a, 0}
  defp to_complex({real, imag}) when is_number(real) and is_number(imag), do: {real, imag}
end
