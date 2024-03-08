defmodule Alan.Model.Post do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    repo Alan.Repo
    table "post"
  end

  code_interface do
    define_for Alan.Model
    define :create
  end

  actions do
    defaults [:create]
  end

  attributes do
    uuid_primary_key :id
  end
end
