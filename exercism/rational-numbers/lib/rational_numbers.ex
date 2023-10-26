defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({num_a, den_a}, {num_b, den_b}) do
    reduce({num_a * den_b + num_b * den_a, den_a * den_b})
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract(a, {num_b, den_b}) do
    add(a, {-num_b, den_b})
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({num_a, den_a}, {num_b, den_b}) do
    reduce({num_a * num_b, den_a * den_b})
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by(num, {num_b, den_b}) do
    multiply(num, {den_b, num_b})
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({num, den}) do
    reduce({Kernel.abs(num), Kernel.abs(den)})
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({num, den}, n) when n < 0, do: pow_rational({den, num}, -n)
  def pow_rational(_a, n) when n == 0, do: {1, 1}
  def pow_rational({num, den}, n), do: reduce({num ** n, den ** n})

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {num, den}) do
    x ** (num / den)
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({0, _den}), do: {0, 1}
  def reduce({_num, 0}), do: {1, 0}
  def reduce({num, den}) when den < 0, do: reduce({-num, -den})

  def reduce({num, den}) do
    2..min(Kernel.abs(num), Kernel.abs(den))
    |> Enum.reduce({num, den}, fn divisor, {num, den} ->
      if rem(num, divisor) == 0 and rem(den, divisor) == 0 do
        {div(num, divisor), div(den, divisor)}
      else
        {num, den}
      end
    end)
  end
end
