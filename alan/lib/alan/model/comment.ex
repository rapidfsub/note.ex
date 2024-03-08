defmodule Alan.Model.Comment do
  use Alan.Prelude
  use M.Template

  attributes do
    attribute :content, :string, allow_nil?: false
    attribute :is_hidden, :boolean, allow_nil?: false
    attribute :is_pinned, :boolean, allow_nil?: false
    timestamps allow_nil?: false
  end

  relationships do
    belongs_to :post, M.Post, allow_nil?: false
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  code_interface do
    define :create
  end

  postgres do
    table "comment"
  end
end
