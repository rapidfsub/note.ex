#!/bin/bash

# Delete migrations and snapshots
ls priv/repo/migrations/[^.]* | xargs rm
rm -rf priv/resource_snapshots

# Regenerate migrations
mix ash_postgres.generate_migrations

# Reset database
mix ecto.reset
