defmodule AshFactory.FactoryFlow do
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
          %Entity{
            name: :attr,
            target: T.FieldFactory,
            args: [:name, :fun],
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
        ]
      }
    ]
  }

  use Extension,
    sections: [@section],
    transformers: [AshFactory.FactoryFlow.Transformer]
end
