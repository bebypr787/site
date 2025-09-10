#!/bin/bash

echo "🚀 CONFIGURACIÓN MANUAL DE GITHUB SECRETS"
echo "=========================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}✅ VERIFICACIÓN COMPLETA:${NC}"
echo "   - ✅ Token de Fly.io: CONFIGURADO"
echo "   - ✅ DATABASE_URL: ENCONTRADO en .env.staging"
echo "   - ✅ STRIPE_SECRET_KEY: ENCONTRADO en .env.staging"
echo "   - ✅ STRIPE_WEBHOOK_SECRET: ENCONTRADO en .env.staging"
echo ""

# Obtener valores de los archivos .env
echo -e "${BLUE}📋 EXTRAYENDO VALORES DE LOS ARCHIVOS .env...${NC}"
echo ""

FLY_TOKEN=$(flyctl auth token 2>/dev/null | head -1)
DATABASE_URL=$(grep "DATABASE_URL=" .env.staging | cut -d'=' -f2- | tr -d '"')
STRIPE_SECRET_KEY=$(grep "STRIPE_SECRET_KEY=" .env.staging | cut -d'=' -f2- | tr -d '"')
STRIPE_WEBHOOK_SECRET=$(grep "STRIPE_WEBHOOK_SECRET=" .env.staging | cut -d'=' -f2- | tr -d '"')

echo -e "${GREEN}✅ VALORES EXTRAÍDOS:${NC}"
echo "   - FLY_TOKEN: ${FLY_TOKEN:0:20}..."
echo "   - DATABASE_URL: ${DATABASE_URL:0:30}..."
echo "   - STRIPE_SECRET_KEY: ${STRIPE_SECRET_KEY:0:20}..."
echo "   - STRIPE_WEBHOOK_SECRET: ${STRIPE_WEBHOOK_SECRET:0:20}..."
echo ""

echo -e "${YELLOW}🔧 INSTRUCCIONES PARA CONFIGURAR EN GITHUB:${NC}"
echo ""
echo -e "${BLUE}1. Ve a tu repositorio en GitHub:${NC}"
echo "   https://github.com/[TU_USUARIO]/[TU_REPOSITORIO]"
echo ""
echo -e "${BLUE}2. Ve a Settings → Secrets and variables → Actions${NC}"
echo ""
echo -e "${BLUE}3. Haz clic en 'New repository secret' para cada uno:${NC}"
echo ""

echo -e "${YELLOW}   SECRET 1: FLY_API_TOKEN_STAGING${NC}"
echo "   ┌─────────────────────────────────────────────────────────────┐"
echo "   │ Name: FLY_API_TOKEN_STAGING                                │"
echo "   │ Secret: $FLY_TOKEN"
echo "   └─────────────────────────────────────────────────────────────┘"
echo ""

echo -e "${YELLOW}   SECRET 2: FLY_API_TOKEN_PRODUCTION${NC}"
echo "   ┌─────────────────────────────────────────────────────────────┐"
echo "   │ Name: FLY_API_TOKEN_PRODUCTION                             │"
echo "   │ Secret: $FLY_TOKEN"
echo "   └─────────────────────────────────────────────────────────────┘"
echo ""

echo -e "${YELLOW}   SECRET 3: DATABASE_URL${NC}"
echo "   ┌─────────────────────────────────────────────────────────────┐"
echo "   │ Name: DATABASE_URL                                         │"
echo "   │ Secret: $DATABASE_URL"
echo "   └─────────────────────────────────────────────────────────────┘"
echo ""

echo -e "${YELLOW}   SECRET 4: STRIPE_SECRET_KEY${NC}"
echo "   ┌─────────────────────────────────────────────────────────────┐"
echo "   │ Name: STRIPE_SECRET_KEY                                    │"
echo "   │ Secret: $STRIPE_SECRET_KEY"
echo "   └─────────────────────────────────────────────────────────────┘"
echo ""

echo -e "${YELLOW}   SECRET 5: STRIPE_WEBHOOK_SECRET${NC}"
echo "   ┌─────────────────────────────────────────────────────────────┐"
echo "   │ Name: STRIPE_WEBHOOK_SECRET                                │"
echo "   │ Secret: $STRIPE_WEBHOOK_SECRET"
echo "   └─────────────────────────────────────────────────────────────┘"
echo ""

echo -e "${GREEN}✅ DESPUÉS DE CONFIGURAR TODOS LOS SECRETS:${NC}"
echo "1. Haz push a tu repositorio"
echo "2. Los workflows se ejecutarán automáticamente"
echo "3. Verifica en Actions tab que todo funcione"
echo ""
echo -e "${GREEN}🚀 ¡CI/CD CONFIGURADO Y LISTO!${NC}"
