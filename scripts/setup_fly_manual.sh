#!/usr/bin/env bash
# Script manual para configurar Fly.io apps
# Uso: ./scripts/setup_fly_manual.sh

set -euo pipefail

APP_STG="contenidosx-app-stg"
APP_PROD="contenidosx-app-prod"

echo "🚀 Configurando apps de Fly.io..."

# 1) Crear apps si no existen
echo "📱 Creando apps (si no existen)..."
flyctl apps create "$APP_STG" || echo "✅ App staging ya existe"
flyctl apps create "$APP_PROD" || echo "✅ App producción ya existe"

# 2) Deploy inicial sin secrets (para verificar que funciona)
echo "🚀 Haciendo deploy inicial a STAGING..."
flyctl deploy --config fly.staging.toml --remote-only

echo "🚀 Haciendo deploy inicial a PRODUCTION..."
flyctl deploy --config fly.production.toml --remote-only

echo "✅ Setup inicial completado!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Ve a https://fly.io/high-risk-unlock para verificar tu cuenta"
echo "2. Una vez verificado, ejecuta: ./scripts/set_fly_secrets.sh $APP_STG .env.staging"
echo "3. Luego ejecuta: ./scripts/set_fly_secrets.sh $APP_PROD .env.production"
echo "4. Haz redeploy: flyctl deploy --config fly.staging.toml --remote-only"
echo "5. Haz redeploy: flyctl deploy --config fly.production.toml --remote-only"
echo ""
echo "🌐 URLs:"
echo "- Staging: https://$APP_STG.fly.dev"
echo "- Producción: https://$APP_PROD.fly.dev"

