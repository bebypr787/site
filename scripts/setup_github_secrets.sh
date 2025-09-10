#!/bin/bash

echo "🔑 CONFIGURACIÓN DE GITHUB SECRETS"
echo "=================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 SECRETS REQUERIDOS PARA GITHUB ACTIONS:${NC}"
echo ""

echo -e "${YELLOW}🔧 SECRETS PARA STAGING:${NC}"
echo "FLY_API_TOKEN_STAGING=fm2_lJPECAAAAAAACgXBxBCufxgq2BltYQ4na+7PunBHwrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABNZjx8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwEwy1SBmz8ayT/SEhDAc3hunWyi0hjyhs02WGHwu2+nuglLahqK84waeOeTMBGrh/DvgwxmwG1CJrSqEDETuVs4OrZGy4fo5hZh9k4kSZ7NjSBvUQk5DOA3gUS969Li3X0H5Y/KrugXsskadYILqvjDaN8uZP39h7FQcyBHMdz/ePgAPMZ/HqNw6fxOcQgaVYE9wuLZs+xC7PENr6q0ttNLqRTeRWZn5lqK0+esz8="
echo ""
echo "DATABASE_URL_STAGING=postgres://postgres:mOEnidzOQM0z6tM@contenidosx-db-stg-1757476394.flycast:5432"
echo ""
echo "STRIPE_SECRET_KEY_STAGING=sk_test_***HIDDEN***"
echo ""
echo "STRIPE_WEBHOOK_SECRET_STAGING=whsec_tTXzOeLzYN0fowsW3nMNeee5ci5Xd4ES"
echo ""
echo "RESEND_API_KEY_STAGING=re_tu_api_key_aqui"
echo ""

echo -e "${YELLOW}🔧 SECRETS PARA PRODUCCIÓN:${NC}"
echo "FLY_API_TOKEN_PRODUCTION=fm2_lJPECAAAAAAACgXBxBCufxgq2BltYQ4na+7PunBHwrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABNZjx8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwEwy1SBmz8ayT/SEhDAc3hunWyi0hjyhs02WGHwu2+nuglLahqK84waeOeTMBGrh/DvgwxmwG1CJrSqEDETuVs4OrZGy4fo5hZh9k4kSZ7NjSBvUQk5DOA3gUS969Li3X0H5Y/KrugXsskadYILqvjDaN8uZP39h7FQcyBHMdz/ePgAPMZ/HqNw6fxOcQgaVYE9wuLZs+xC7PENr6q0ttNLqRTeRWZn5lqK0+esz8="
echo ""
echo "DATABASE_URL_PRODUCTION=postgres://postgres:uMR7Cab42AAZzuw@contenidosx-db-prod-1757476439.flycast:5432"
echo ""
echo "STRIPE_SECRET_KEY_PRODUCTION=sk_live_dummy_stripe_secret_key_for_production"
echo ""
echo "STRIPE_WEBHOOK_SECRET_PRODUCTION=whsec_Ih1dUub93jBgH8pmfwMIBuCG4JIytBH7"
echo ""
echo "RESEND_API_KEY_PRODUCTION=re_tu_api_key_aqui"
echo ""

echo -e "${GREEN}📋 INSTRUCCIONES PARA CONFIGURAR:${NC}"
echo ""
echo "1. 🌐 Ve a tu repositorio en GitHub"
echo "2. ⚙️ Settings → Secrets and variables → Actions"
echo "3. ➕ Haz clic en 'New repository secret'"
echo "4. 📝 Agrega cada secret con su nombre y valor"
echo "5. 💾 Haz clic en 'Add secret'"
echo ""
echo -e "${BLUE}🎯 SECRETS CRÍTICOS:${NC}"
echo "- FLY_API_TOKEN (para ambos entornos)"
echo "- DATABASE_URL (para ambos entornos)"
echo "- STRIPE_SECRET_KEY (para ambos entornos)"
echo "- STRIPE_WEBHOOK_SECRET (para ambos entornos)"
echo "- RESEND_API_KEY (para ambos entornos)"
echo ""
echo -e "${YELLOW}⚠️ IMPORTANTE:${NC}"
echo "- Usa los valores reales, no los dummy"
echo "- Mantén los secrets seguros"
echo "- No los compartas públicamente"
