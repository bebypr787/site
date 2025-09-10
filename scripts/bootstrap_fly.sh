#!/usr/bin/env bash
# Bootstrap de entornos Fly (staging y production)
# Requisitos: flyctl instalado y logueado (flyctl auth login), y FLY_API_TOKEN exportado o en el keychain.
# Uso: ./scripts/bootstrap_fly.sh

set -euo pipefail

APP_STG="contenidosx-app-stg"
APP_PROD="contenidosx-app-prod"

# 1) Crear apps si no existen
echo "Creando apps (si no existen)..."
flyctl apps create "$APP_STG" || echo "(stg ya existe)"
flyctl apps create "$APP_PROD" || echo "(prod ya existe)"

# 2) Setear secrets desde .env.staging y .env.production (si existen)
if [ -f ".env.staging" ]; then
  ./scripts/set_fly_secrets.sh "$APP_STG" ".env.staging"
else
  echo "Aviso: .env.staging no encontrado (salteando secrets de staging)"
fi

if [ -f ".env.production" ]; then
  ./scripts/set_fly_secrets.sh "$APP_PROD" ".env.production"
else
  echo "Aviso: .env.production no encontrado (salteando secrets de producción)"
fi

# 3) Primer deploy (staging y prod) usando tomls dedicados
echo "Haciendo primer deploy a STAGING..."
flyctl deploy --config fly.staging.toml --remote-only

echo "Haciendo primer deploy a PRODUCTION..."
flyctl deploy --config fly.production.toml --remote-only

echo "Bootstrap completado. Revisa el dashboard de Fly para dominios/certificados."
