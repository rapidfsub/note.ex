defmodule Bed.Model.Template do
  defmacro __using__(_opts) do
    quote do
      postgres do
        repo Bed.Repo
      end

      code_interface do
        define_for Bed.Model
      end

      actions do
        defaults [:create, :read, :update, :destroy]
      end

      attributes do
        uuid_primary_key :id
      end
    end
  end
end
