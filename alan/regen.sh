#!/bin/bash

# Delete untracked migrations and snapshots
rm -rf priv/repo/migrations
rm -rf priv/resource_snapshots

# Regenerate migrations
mix ash_postgres.generate_migrations

# Run migrations if flag
if echo $* | grep -e "-m" -q; then
  mix ecto.migrate
fi
