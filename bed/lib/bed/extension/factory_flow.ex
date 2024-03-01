defmodule Bed.Extension.FactoryFlow do
  use Bed.Prelude.Ash

  defmodule FieldFactory do
    defstruct [:name, :fun]
  end

  @section %Section{
    name: :factory,
    schema: [
      api: [
        type: {:behaviour, Ash.Api},
        required: true
      ],
      resource: [
        type: {:behaviour, Ash.Resource},
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
            target: FieldFactory,
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
    transformers: [Bed.Extension.FactoryFlow.Transformer]
end
