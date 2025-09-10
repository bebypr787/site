#!/bin/bash

echo "🧪 TESTING WEBHOOK EN MODO LIVE"
echo "==============================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 VERIFICANDO CONFIGURACIÓN:${NC}"
echo ""

# Verificar que la aplicación esté funcionando
echo -e "${YELLOW}1. 🚀 Verificando aplicación de producción:${NC}"
PROD_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://contenidosx-app-prod.fly.dev)
if [ "$PROD_RESPONSE" = "200" ]; then
    echo -e "   ${GREEN}✅ Aplicación de producción funcionando (HTTP $PROD_RESPONSE)${NC}"
else
    echo -e "   ${RED}❌ Aplicación de producción no accesible (HTTP $PROD_RESPONSE)${NC}"
fi
echo ""

# Verificar webhook endpoint
echo -e "${YELLOW}2. 🔗 Verificando webhook endpoint:${NC}"
WEBHOOK_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST https://contenidosx-app-prod.fly.dev/api/webhooks/stripe -H "Content-Type: application/json" -d '{"test": "webhook"}')
if [ "$WEBHOOK_RESPONSE" = "400" ]; then
    echo -e "   ${GREEN}✅ Webhook endpoint funcionando (HTTP $WEBHOOK_RESPONSE - esperado sin signature)${NC}"
else
    echo -e "   ${RED}❌ Webhook endpoint error (HTTP $WEBHOOK_RESPONSE)${NC}"
fi
echo ""

# Verificar secrets en Fly.io
echo -e "${YELLOW}3. 🔑 Verificando secrets en Fly.io:${NC}"
echo "   Ejecutando: flyctl secrets list --app contenidosx-app-prod"
echo ""

# Mostrar instrucciones
echo -e "${BLUE}📋 INSTRUCCIONES PARA CONFIGURAR WEBHOOK EN MODO LIVE:${NC}"
echo ""
echo "1. 🌐 Ve a: https://dashboard.stripe.com/webhooks"
echo "2. 🔄 Cambia a modo LIVE (esquina superior derecha)"
echo "3. ➕ Haz clic en 'Add endpoint'"
echo "4. 📝 Configura:"
echo "   - URL: https://contenidosx-app-prod.fly.dev/api/webhooks/stripe"
echo "   - Eventos: customer.subscription.*, invoice.payment.*, checkout.session.completed"
echo "5. 💾 Copia el 'Signing secret' (empieza con whsec_)"
echo "6. 🔧 Ejecuta: flyctl secrets set STRIPE_WEBHOOK_SECRET_PRODUCTION=whsec_tu_secret --app contenidosx-app-prod"
echo ""
echo -e "${GREEN}🎯 DESPUÉS DE CONFIGURAR:${NC}"
echo "Ejecuta: ./scripts/verify_stripe_setup.sh"
