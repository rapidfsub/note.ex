#!/bin/bash

# Delete migrations and snapshots
rm ./priv/repo/migrations/2*.exs
rm -rf ./priv/resource_snapshots/

# Regenerate migrations
mix ash_postgres.generate_migrations genesis

# Run migrations if flag
if echo $* | grep -e "-m" -q
then
  mix ecto.migrate
fi
