defmodule AshFactory.Factory do
  use AshFactory.Prelude
  use Prelude.Ash

  @field_factory %Entity{
    name: :attr,
    args: [:name, :fun],
    target: T.FieldFactory,
    schema: [
      name: [
        type: :atom,
        required: true
      ],
      fun: [
        type: {:fun, 0},
        required: true
      ]
    ]
  }

  @record_factory %Entity{
    name: :factory,
    args: [:name],
    target: T.ActionFactory,
    schema: [
      name: [
        type: :atom,
        required: true
      ]
    ],
    entities: [
      attrs: [@field_factory]
    ]
  }
  @sections [
    %Section{
      name: :factories,
      entities: [@record_factory]
    }
  ]

  use Spark.Dsl.Extension,
    sections: @sections,
    transformers: [AshFactory.Factory.Transformer]
end
