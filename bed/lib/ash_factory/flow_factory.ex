defmodule AshFactory.FlowFactory do
  use AshFactory.Prelude
  use Prelude.Ash

  @section %Section{
    name: :factory,
    schema: [
      api: [
        type: {:behaviour, Api},
        required: true
      ],
      resource: [
        type: {:behaviour, Resource},
        required: true
      ],
      action: [
        type: :atom,
        required: true
      ]
    ],
    sections: [
      %Section{
        name: :attrs,
        entities: [
          T.FieldFactory.entity()
        ]
      }
    ]
  }

  use Extension,
    sections: [@section],
    transformers: [__MODULE__.Transformer]
end
