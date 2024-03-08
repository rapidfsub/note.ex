defmodule Alan.Model.Post do
  use Alan.Prelude
  use M.Template

  attributes do
    attribute :title, :string, allow_nil?: false
    timestamps allow_nil?: false
  end

  relationships do
    has_many :comments, M.Comment
    has_many :hidden_comments, M.Comment, filter: expr(is_hidden)
    has_one :pinned_comment, M.Comment, filter: expr(is_pinned)
  end

  actions do
    create :create do
      primary? true
      argument :comments, {:array, :map}
      change manage_relationship(:comments, type: :direct_control)
    end
  end

  code_interface do
    define :create
  end

  postgres do
    table "post"
  end
end
