defmodule AshFactory.Target.FieldFactory do
  defstruct [:name, :fun]

  def fun(Ash.Type.String) do
    &Faker.Lorem.word/0
  end

  def fun(Ash.Type.CiString) do
    &Faker.Lorem.word/0
  end

  def fun(Ash.Type.Decimal) do
    &__MODULE__.decimal_fun/0
  end

  def decimal_fun() do
    Enum.random(1..100)
  end
end
