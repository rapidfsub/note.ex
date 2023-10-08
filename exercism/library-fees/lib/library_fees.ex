defmodule LibraryFees do
  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(datetime) do
    datetime.hour < 12
  end

  def return_date(checkout_datetime) do
    days =
      if before_noon?(checkout_datetime) do
        28
      else
        29
      end

    Date.add(checkout_datetime, days)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> max(0)
  end

  def monday?(datetime) do
    Date.day_of_week(datetime) == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    planned = datetime_from_string(checkout) |> return_date()
    actual = datetime_from_string(return)
    result = days_late(planned, actual) * rate

    if monday?(actual) do
      floor(result / 2)
    else
      result
    end
  end
end
