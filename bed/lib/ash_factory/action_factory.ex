defmodule AshFactory.ActionFactory do
  use Prelude.Ash

  @factories %Section{
    name: :factories,
    entities: [
      AshFactory.ActionFactory.Entity.ResourceGeneratorAction.entity()
    ],
    schema: [
      primary?: [
        type: :boolean,
        default: false
      ]
    ]
  }

  use Extension,
    sections: [@factories],
    transformers: [AshFactory.ActionFactory.Transformer]
end
