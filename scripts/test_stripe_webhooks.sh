#!/bin/bash

echo "🧪 TESTING DE WEBHOOKS DE STRIPE"
echo "================================"
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 VERIFICANDO WEBHOOKS...${NC}"
echo ""

# Test staging webhook
echo -e "${YELLOW}📡 Testing Staging Webhook:${NC}"
STAGING_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://contenidosx-app-stg.fly.dev/api/webhooks/stripe)
if [ "$STAGING_RESPONSE" = "200" ] || [ "$STAGING_RESPONSE" = "400" ]; then
    echo -e "${GREEN}✅ Staging webhook endpoint accessible (HTTP $STAGING_RESPONSE)${NC}"
else
    echo -e "${RED}❌ Staging webhook endpoint not accessible (HTTP $STAGING_RESPONSE)${NC}"
fi

echo ""

# Test production webhook
echo -e "${YELLOW}📡 Testing Production Webhook:${NC}"
PROD_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://contenidosx-app-prod.fly.dev/api/webhooks/stripe)
if [ "$PROD_RESPONSE" = "200" ] || [ "$PROD_RESPONSE" = "400" ]; then
    echo -e "${GREEN}✅ Production webhook endpoint accessible (HTTP $PROD_RESPONSE)${NC}"
else
    echo -e "${RED}❌ Production webhook endpoint not accessible (HTTP $PROD_RESPONSE)${NC}"
fi

echo ""
echo -e "${BLUE}📋 PRÓXIMOS PASOS:${NC}"
echo "1. Ve a https://dashboard.stripe.com/webhooks"
echo "2. Verifica que los webhooks estén configurados correctamente"
echo "3. Revisa los logs de webhook en Stripe para ver si hay errores"
echo "4. Prueba una suscripción de test para verificar el flujo completo"
echo ""
echo -e "${GREEN}🎯 PARA PROBAR UNA SUSCRIPCIÓN:${NC}"
echo "1. Ve a https://contenidosx-app-stg.fly.dev"
echo "2. Crea una cuenta y perfil de creador"
echo "3. Intenta suscribirte a un creador"
echo "4. Usa las tarjetas de test de Stripe"
