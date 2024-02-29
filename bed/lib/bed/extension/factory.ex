defmodule Bed.Extension.Factory do
  @sections [
    %Spark.Dsl.Section{
      name: :factories,
      entities: [
        %Spark.Dsl.Entity{
          name: :factory,
          args: [:name],
          target: Bed.Extension.Factory.Action,
          schema: [
            name: [
              type: :atom,
              required: true
            ]
          ],
          entities: [
            attrs: [
              %Spark.Dsl.Entity{
                name: :attr,
                args: [:name, :fun],
                target: Bed.Extension.Factory.Attr,
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
          ]
        }
      ]
    }
  ]

  use Spark.Dsl.Extension,
    sections: @sections,
    transformers: [Bed.Extension.Factory.Transformer]
end
