defmodule Alan.Model.Post do
  use Alan.Prelude
  use M.Template

  postgres do
    table "post"
  end

  code_interface do
    define :create
  end

  actions do
    defaults [:create]
  end
end
