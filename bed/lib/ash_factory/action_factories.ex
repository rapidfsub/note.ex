# defmodule AshFactory.ActionFactories do
#   use AshFactory.Prelude
#   use Prelude.Ash

#   @record_factory %Entity{
#     name: :factory,
#     args: [:name],
#     target: T.ActionFactory,
#     schema: [
#       name: [
#         type: :atom,
#         required: true
#       ]
#     ],
#     entities: [
#       attrs: [
#         T.FieldFactory.entity()
#       ]
#     ]
#   }

#   @sections [
#     %Section{
#       name: :factories,
#       entities: [@record_factory]
#     }
#   ]

#   use Spark.Dsl.Extension,
#     sections: @sections,
#     transformers: [__MODULE__.Transformer]
# end
