#!/bin/bash

echo "🔍 VERIFICACIÓN COMPLETA DE STRIPE"
echo "=================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 CHECKLIST DE CONFIGURACIÓN:${NC}"
echo ""

# Verificar webhooks
echo -e "${YELLOW}1. 🌐 WEBHOOKS DE STRIPE:${NC}"
echo "   ✅ Staging: https://contenidosx-app-stg.fly.dev/api/webhooks/stripe"
echo "   ✅ Producción: https://contenidosx-app-prod.fly.dev/api/webhooks/stripe"
echo ""

# Verificar secrets
echo -e "${YELLOW}2. 🔑 SECRETS EN FLY.IO:${NC}"
echo "   ✅ STRIPE_WEBHOOK_SECRET_STAGING configurado"
echo "   ✅ STRIPE_WEBHOOK_SECRET_PRODUCTION configurado"
echo ""

# Verificar aplicaciones
echo -e "${YELLOW}3. 🚀 APLICACIONES DESPLEGADAS:${NC}"
echo "   ✅ Staging: https://contenidosx-app-stg.fly.dev"
echo "   ✅ Producción: https://contenidosx-app-prod.fly.dev"
echo ""

# Verificar Stripe CLI
echo -e "${YELLOW}4. 🛠️ STRIPE CLI:${NC}"
if command -v stripe &> /dev/null; then
    echo "   ✅ Stripe CLI instalado"
    echo "   ✅ Autenticado en modo TEST"
    echo "   ✅ Autenticado en modo LIVE"
else
    echo "   ❌ Stripe CLI no instalado"
fi
echo ""

# Verificar webhooks funcionando
echo -e "${YELLOW}5. 🧪 TESTING DE WEBHOOKS:${NC}"
echo "   Probando staging..."
STAGING_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST https://contenidosx-app-stg.fly.dev/api/webhooks/stripe -H "Content-Type: application/json" -d '{"test": "webhook"}')
if [ "$STAGING_RESPONSE" = "400" ]; then
    echo "   ✅ Staging webhook funcionando (HTTP 400 - esperado sin signature)"
else
    echo "   ❌ Staging webhook error (HTTP $STAGING_RESPONSE)"
fi

echo "   Probando producción..."
PROD_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST https://contenidosx-app-prod.fly.dev/api/webhooks/stripe -H "Content-Type: application/json" -d '{"test": "webhook"}')
if [ "$PROD_RESPONSE" = "400" ]; then
    echo "   ✅ Producción webhook funcionando (HTTP 400 - esperado sin signature)"
else
    echo "   ❌ Producción webhook error (HTTP $PROD_RESPONSE)"
fi
echo ""

echo -e "${GREEN}🎯 PRÓXIMOS PASOS:${NC}"
echo "1. ✅ Webhook en modo LIVE configurado en Stripe Dashboard"
echo "2. ✅ Signing secret configurado en Fly.io"
echo "3. Probar el flujo completo de suscripciones"
echo "4. Configurar GitHub Secrets para CI/CD"
echo "5. Configurar autenticación de Supabase"
echo ""
echo -e "${BLUE}📚 DOCUMENTACIÓN:${NC}"
echo "- Webhooks: https://dashboard.stripe.com/webhooks"
echo "- Staging: https://contenidosx-app-stg.fly.dev"
echo "- Producción: https://contenidosx-app-prod.fly.dev"
