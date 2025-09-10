#!/usr/bin/env sh
set -e
FILE="$1"
if [ -z "$FILE" ]; then
  echo "Uso: ./scripts/migrate.sh migrations/<archivo>.sql"
  exit 1
fi
if [ -z "$DATABASE_URL" ]; then
  echo "Falta DATABASE_URL (postgres://user:pass@host:port/dbname)"
  echo "Tip: en Supabase -> Project Settings -> Database -> Connection string"
  exit 1
fi
echo "Aplicando migración: $FILE"
psql "$DATABASE_URL" -v "ON_ERROR_STOP=1" -f "$FILE"
echo "OK"
