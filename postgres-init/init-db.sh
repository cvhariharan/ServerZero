#!/bin/bash
set -e

echo $POSTGRES_DB

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE miniflux;
    CREATE DATABASE paperless;
EOSQL
