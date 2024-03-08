defmodule Alan.Model.Template do
  defmacro __using__(_opts) do
    quote do
      use Ash.Resource,
        data_layer: AshPostgres.DataLayer

      postgres do
        repo Alan.Repo
      end

      code_interface do
        define_for Alan.Model
      end

      attributes do
        uuid_primary_key :id
      end
    end
  end
end
