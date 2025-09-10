#!/bin/bash

echo "🔗 CONFIGURACIÓN DE WEBHOOKS DE STRIPE"
echo "====================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 PASOS PARA CONFIGURAR WEBHOOKS:${NC}"
echo ""
echo "1. 🌐 Ve a https://dashboard.stripe.com/webhooks"
echo "2. 🔧 Haz clic en 'Add endpoint'"
echo ""
echo -e "${YELLOW}📌 WEBHOOK PARA STAGING (MODO TEST):${NC}"
echo "URL: https://contenidosx-app-stg.fly.dev/api/webhooks/stripe"
echo "Eventos a seleccionar:"
echo "  - customer.subscription.created"
echo "  - customer.subscription.updated"
echo "  - customer.subscription.deleted"
echo "  - invoice.payment_succeeded"
echo "  - invoice.payment_failed"
echo ""
echo -e "${YELLOW}📌 WEBHOOK PARA PRODUCCIÓN (MODO LIVE):${NC}"
echo "URL: https://contenidosx-app-prod.fly.dev/api/webhooks/stripe"
echo "Eventos a seleccionar:"
echo "  - customer.subscription.created"
echo "  - customer.subscription.updated"
echo "  - customer.subscription.deleted"
echo "  - invoice.payment_succeeded"
echo "  - invoice.payment_failed"
echo ""
echo -e "${GREEN}✅ DESPUÉS DE CREAR CADA WEBHOOK:${NC}"
echo "1. Copia el 'Signing secret' (empieza con whsec_)"
echo "2. Ejecuta este script para actualizar los archivos .env"
echo ""
echo -e "${BLUE}🔧 COMANDO PARA ACTUALIZAR SECRETS:${NC}"
echo "flyctl secrets set STRIPE_WEBHOOK_SECRET_STAGING=whsec_tu_secret_aqui --app contenidosx-app-stg"
echo "flyctl secrets set STRIPE_WEBHOOK_SECRET_PRODUCTION=whsec_tu_secret_aqui --app contenidosx-app-prod"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
echo "- Asegúrate de estar en el modo correcto (Test/Live) en Stripe"
echo "- Los webhooks deben apuntar a las URLs exactas mostradas arriba"
echo "- Guarda los signing secrets de forma segura"
echo ""
echo -e "${GREEN}🎯 PRÓXIMO PASO:${NC}"
echo "Una vez configurados los webhooks, ejecuta:"
echo "./scripts/test_stripe_webhooks.sh"
