# defmodule AshFactory.Target.FieldFactory do
#   use Prelude.Ash

#   defstruct [:name, :fun]

#   def entity() do
#     %Entity{
#       name: :attr,
#       target: __MODULE__,
#       args: [:name, :fun],
#       schema: [
#         name: [
#           type: :atom,
#           required: true
#         ],
#         fun: [
#           type: {:fun, 0},
#           required: true
#         ]
#       ]
#     }
#   end

#   def fun(Ash.Type.String) do
#     &Faker.Lorem.word/0
#   end

#   def fun(Ash.Type.CiString) do
#     &Faker.Lorem.word/0
#   end

#   def fun(Ash.Type.Decimal) do
#     &__MODULE__.decimal_fun/0
#   end

#   def decimal_fun() do
#     Enum.random(1..100)
#   end
# end
