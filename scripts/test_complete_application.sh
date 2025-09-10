#!/bin/bash

echo "🧪 TESTING COMPLETO DE LA APLICACIÓN"
echo "===================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 TESTING DE FUNCIONALIDADES:${NC}"
echo ""

# Test 1: Verificar aplicaciones
echo -e "${YELLOW}1. 🚀 Verificando aplicaciones desplegadas:${NC}"
echo "   Probando staging..."
STAGING_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://contenidosx-app-stg.fly.dev)
if [ "$STAGING_RESPONSE" = "200" ]; then
    echo -e "   ${GREEN}✅ Staging funcionando (HTTP $STAGING_RESPONSE)${NC}"
else
    echo -e "   ${RED}❌ Staging error (HTTP $STAGING_RESPONSE)${NC}"
fi

echo "   Probando producción..."
PROD_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://contenidosx-app-prod.fly.dev)
if [ "$PROD_RESPONSE" = "200" ]; then
    echo -e "   ${GREEN}✅ Producción funcionando (HTTP $PROD_RESPONSE)${NC}"
else
    echo -e "   ${RED}❌ Producción error (HTTP $PROD_RESPONSE)${NC}"
fi
echo ""

# Test 2: Verificar endpoints de API
echo -e "${YELLOW}2. 🔗 Verificando endpoints de API:${NC}"
echo "   Probando webhook de Stripe..."
WEBHOOK_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST https://contenidosx-app-stg.fly.dev/api/webhooks/stripe -H "Content-Type: application/json" -d '{"test": "webhook"}')
if [ "$WEBHOOK_RESPONSE" = "400" ]; then
    echo -e "   ${GREEN}✅ Webhook funcionando (HTTP $WEBHOOK_RESPONSE - esperado sin signature)${NC}"
else
    echo -e "   ${RED}❌ Webhook error (HTTP $WEBHOOK_RESPONSE)${NC}"
fi
echo ""

# Test 3: Verificar páginas principales
echo -e "${YELLOW}3. 📄 Verificando páginas principales:${NC}"
echo "   Probando página de inicio..."
HOME_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://contenidosx-app-stg.fly.dev/)
if [ "$HOME_RESPONSE" = "200" ]; then
    echo -e "   ${GREEN}✅ Página de inicio funcionando (HTTP $HOME_RESPONSE)${NC}"
else
    echo -e "   ${RED}❌ Página de inicio error (HTTP $HOME_RESPONSE)${NC}"
fi

echo "   Probando página de autenticación..."
AUTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://contenidosx-app-stg.fly.dev/auth)
if [ "$AUTH_RESPONSE" = "200" ]; then
    echo -e "   ${GREEN}✅ Página de autenticación funcionando (HTTP $AUTH_RESPONSE)${NC}"
else
    echo -e "   ${RED}❌ Página de autenticación error (HTTP $AUTH_RESPONSE)${NC}"
fi

echo "   Probando feed..."
FEED_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://contenidosx-app-stg.fly.dev/feed)
if [ "$FEED_RESPONSE" = "200" ]; then
    echo -e "   ${GREEN}✅ Feed funcionando (HTTP $FEED_RESPONSE)${NC}"
else
    echo -e "   ${RED}❌ Feed error (HTTP $FEED_RESPONSE)${NC}"
fi
echo ""

echo -e "${GREEN}🎯 PRÓXIMOS PASOS PARA TESTING MANUAL:${NC}"
echo ""
echo "1. 🌐 Ve a: https://contenidosx-app-stg.fly.dev"
echo "2. 👤 Crea una cuenta nueva"
echo "3. 📝 Completa tu perfil de usuario"
echo "4. 🎨 Crea un perfil de creador"
echo "5. 📝 Publica contenido"
echo "6. 💳 Prueba una suscripción con tarjetas de test de Stripe"
echo "7. 🔒 Verifica que el paywall funcione"
echo ""
echo -e "${BLUE}💳 TARJETAS DE TEST DE STRIPE:${NC}"
echo "- 4242 4242 4242 4242 (Visa exitosa)"
echo "- 4000 0000 0000 0002 (Tarjeta rechazada)"
echo "- 4000 0000 0000 9995 (Fondos insuficientes)"
echo ""
echo -e "${YELLOW}⚠️ IMPORTANTE:${NC}"
echo "- Usa solo tarjetas de test en staging"
echo "- Verifica que los webhooks funcionen"
echo "- Prueba el flujo completo de suscripciones"
