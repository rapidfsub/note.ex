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
    attribute :month, :integer, allow_nil?: false
    attribute :day, :integer, allow_nil?: false
    attribute :calendar_kind, Itch.Enum.CalendarKind, allow_nil?: false
  end

  identities do
    identity :unique_name, :name
  end

  actions do
    defaults [:create, :read]

    create :upsert do
      upsert? true
      upsert_identity :unique_name
    end

    read :list_by_type do
      argument :calendar_kind, Itch.Enum.CalendarKind
      filter expr(is_nil(^arg(:calendar_kind)) or calendar_kind == ^arg(:calendar_kind))
    end
  end

  code_interface do
    define_for Itch.Api
    define :create
    define :read
    define :upsert
    define :list_by_type, args: [:calendar_kind]
  end
end
