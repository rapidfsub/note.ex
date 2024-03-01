defmodule Bed.Extension.FieldFactory do
  defstruct [:name, :fun]

  def fun(Ash.Type.String) do
    &Faker.Lorem.word/0
  end

  def fun(Ash.Type.CiString) do
    &Faker.Lorem.word/0
  end

  def fun(Ash.Type.Decimal) do
    fn -> Enum.random(1..100) end
  end
end
