defmodule Bed.Model.Identity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  use Bed.Model.Template

  postgres do
    table "identity"
  end
end
