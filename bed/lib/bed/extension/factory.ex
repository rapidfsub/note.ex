defmodule Bed.Extension.Factory do
  use Bed.Prelude.Ash

  defmodule RecordFactory do
    defstruct [:name, :attrs]
  end

  defmodule FieldFactory do
    defstruct [:name, :fun]
  end

  @field_factory %Entity{
    name: :attr,
    args: [:name, :fun],
    target: FieldFactory,
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
    target: RecordFactory,
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
    transformers: [Bed.Extension.Factory.Transformer]
end
