defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    before_discount * (100.0 - discount) / 100.0
  end

  defp discounted_daily_rate(hourly_rate, discount) do
    hourly_rate |> daily_rate() |> apply_discount(discount)
  end

  def monthly_rate(hourly_rate, discount) do
    (discounted_daily_rate(hourly_rate, discount) * 22.0) |> ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    (budget / discounted_daily_rate(hourly_rate, discount)) |> Float.floor(1)
  end
end
