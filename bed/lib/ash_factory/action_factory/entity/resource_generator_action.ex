defmodule AshFactory.ActionFactory.Entity.ResourceGeneratorAction do
  use Prelude.Ash

  defstruct [:primary?, :name, :attributes]

  def entity() do
    %Entity{
      target: __MODULE__,
      name: :factory,
      args: [:name],
      schema: [
        primary?: [
          type: :boolean,
          default: false
        ],
        name: [
          type: :atom,
          required: true
        ]
      ],
      entities: [
        attributes: [
          AshFactory.ActionFactory.Entity.AttributeGenerator.entity()
        ]
      ]
    }
  end
end
