defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    hourly_rate * 8.0
  end

  defp daily_rate(hourly_rate, discount) do
    hourly_rate
    |> daily_rate()
    |> apply_discount(discount)
  end

  def apply_discount(before_discount, discount) do
    before_discount * (100 - discount) / 100
  end

  def monthly_rate(hourly_rate, discount) do
    ceil(daily_rate(hourly_rate, discount) * 22.0)
  end

  def days_in_budget(budget, hourly_rate, discount) do
    Float.floor(budget / daily_rate(hourly_rate, discount), 1)
  end
end
