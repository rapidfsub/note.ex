defmodule Itch.Resource.Anniversary do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "anniversary"
    repo Itch.Repo
  end

  attributes do
    integer_primary_key :id
    attribute :name, :ci_string, allow_nil?: false
    attribute :date, :date, allow_nil?: false
  end
end
