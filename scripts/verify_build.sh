#!/usr/bin/env bash
# Script para verificar que el proyecto está listo para deploy
# Uso: ./scripts/verify_build.sh

set -euo pipefail

echo "🔍 Verificando que ContenidosX está listo para deploy..."

# 1) Verificar que el proyecto compila
echo "📦 Verificando compilación..."
npm run build

# 2) Verificar archivos de configuración
echo "📋 Verificando archivos de configuración..."

if [ -f "fly.staging.toml" ]; then
    echo "✅ fly.staging.toml encontrado"
else
    echo "❌ fly.staging.toml no encontrado"
    exit 1
fi

if [ -f "fly.production.toml" ]; then
    echo "✅ fly.production.toml encontrado"
else
    echo "❌ fly.production.toml no encontrado"
    exit 1
fi

if [ -f ".env.staging" ]; then
    echo "✅ .env.staging encontrado"
else
    echo "❌ .env.staging no encontrado"
    exit 1
fi

if [ -f ".env.production" ]; then
    echo "✅ .env.production encontrado"
else
    echo "❌ .env.production no encontrado"
    exit 1
fi

# 3) Verificar Dockerfile
if [ -f "Dockerfile" ]; then
    echo "✅ Dockerfile encontrado"
else
    echo "❌ Dockerfile no encontrado"
    exit 1
fi

# 4) Verificar workflows de GitHub
if [ -f ".github/workflows/deploy-fly-staging.yml" ]; then
    echo "✅ Workflow de staging encontrado"
else
    echo "❌ Workflow de staging no encontrado"
    exit 1
fi

if [ -f ".github/workflows/deploy-fly-production.yml" ]; then
    echo "✅ Workflow de producción encontrado"
else
    echo "❌ Workflow de producción no encontrado"
    exit 1
fi

echo ""
echo "🎉 ¡ContenidosX está listo para deploy!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Ve a https://fly.io/high-risk-unlock para verificar tu cuenta"
echo "2. Una vez verificado, ejecuta: ./scripts/setup_fly_manual.sh"
echo "3. Configura los secrets reales en GitHub"
echo "4. Configura los webhooks de Stripe"
echo "5. ¡Tu app estará desplegada!"
echo ""
echo "🌐 URLs que estarán disponibles:"
echo "- Staging: https://contenidosx-app-stg.fly.dev"
echo "- Producción: https://contenidosx-app-prod.fly.dev"

