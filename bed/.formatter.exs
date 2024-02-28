[
  import_deps: ~w[
    ecto ecto_sql phoenix ash ash_authentication ash_authentication_phoenix ash_phoenix ash_postgres
  ]a,
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
