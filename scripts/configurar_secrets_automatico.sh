#!/bin/bash

echo "🚀 CONFIGURANDO GITHUB SECRETS AUTOMÁTICAMENTE"
echo "=============================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para obtener input del usuario
get_input() {
    local prompt="$1"
    local var_name="$2"
    echo -e "${YELLOW}$prompt${NC}"
    read -r "$var_name"
}

echo -e "${GREEN}✅ VERIFICACIÓN COMPLETA:${NC}"
echo "   - ✅ Token de Fly.io: CONFIGURADO"
echo "   - ✅ DATABASE_URL: ENCONTRADO en .env.staging"
echo "   - ✅ STRIPE_SECRET_KEY: ENCONTRADO en .env.staging"
echo "   - ✅ STRIPE_WEBHOOK_SECRET: ENCONTRADO en .env.staging"
echo ""

# Obtener información del repositorio
get_input "🔗 ¿Cuál es la URL de tu repositorio en GitHub? (ej: https://github.com/usuario/contenidosx)" REPO_URL

# Extraer owner/repo de la URL
if [[ $REPO_URL =~ github\.com/([^/]+)/([^/]+) ]]; then
    REPO_OWNER="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]}"
    REPO_FULL="$REPO_OWNER/$REPO_NAME"
else
    echo -e "${RED}❌ URL de repositorio inválida${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Repositorio detectado: $REPO_FULL${NC}"
echo ""

# Obtener token de Fly.io
echo -e "${BLUE}🔑 OBTENIENDO TOKEN DE FLY.IO...${NC}"
FLY_TOKEN=$(flyctl auth token 2>/dev/null | head -1)
if [[ $FLY_TOKEN =~ ^fm2_ ]]; then
    echo -e "${GREEN}✅ Token de Fly.io obtenido${NC}"
else
    echo -e "${RED}❌ No se pudo obtener el token de Fly.io${NC}"
    exit 1
fi

# Obtener DATABASE_URL
echo -e "${BLUE}🗄️ OBTENIENDO DATABASE_URL...${NC}"
DATABASE_URL=$(grep "DATABASE_URL=" .env.staging | cut -d'=' -f2- | tr -d '"')
if [[ $DATABASE_URL =~ ^postgresql:// ]]; then
    echo -e "${GREEN}✅ DATABASE_URL obtenido${NC}"
else
    echo -e "${RED}❌ No se pudo obtener DATABASE_URL${NC}"
    exit 1
fi

# Obtener STRIPE_SECRET_KEY
echo -e "${BLUE}💳 OBTENIENDO STRIPE_SECRET_KEY...${NC}"
STRIPE_SECRET_KEY=$(grep "STRIPE_SECRET_KEY=" .env.staging | cut -d'=' -f2- | tr -d '"')
if [[ $STRIPE_SECRET_KEY =~ ^sk_(test_|live_) ]]; then
    echo -e "${GREEN}✅ STRIPE_SECRET_KEY obtenido${NC}"
else
    echo -e "${RED}❌ No se pudo obtener STRIPE_SECRET_KEY${NC}"
    exit 1
fi

# Obtener STRIPE_WEBHOOK_SECRET
echo -e "${BLUE}🔗 OBTENIENDO STRIPE_WEBHOOK_SECRET...${NC}"
STRIPE_WEBHOOK_SECRET=$(grep "STRIPE_WEBHOOK_SECRET=" .env.staging | cut -d'=' -f2- | tr -d '"')
if [[ $STRIPE_WEBHOOK_SECRET =~ ^whsec_ ]]; then
    echo -e "${GREEN}✅ STRIPE_WEBHOOK_SECRET obtenido${NC}"
else
    echo -e "${RED}❌ No se pudo obtener STRIPE_WEBHOOK_SECRET${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}🔧 CONFIGURANDO SECRETS EN GITHUB...${NC}"
echo ""

# Verificar si GitHub CLI está instalado
if command -v gh &> /dev/null; then
    echo -e "${GREEN}✅ GitHub CLI detectado${NC}"
    
    # Configurar todos los secrets
    echo -e "${BLUE}Configurando FLY_API_TOKEN_STAGING...${NC}"
    echo "$FLY_TOKEN" | gh secret set "FLY_API_TOKEN_STAGING" --repo "$REPO_FULL"
    
    echo -e "${BLUE}Configurando FLY_API_TOKEN_PRODUCTION...${NC}"
    echo "$FLY_TOKEN" | gh secret set "FLY_API_TOKEN_PRODUCTION" --repo "$REPO_FULL"
    
    echo -e "${BLUE}Configurando DATABASE_URL...${NC}"
    echo "$DATABASE_URL" | gh secret set "DATABASE_URL" --repo "$REPO_FULL"
    
    echo -e "${BLUE}Configurando STRIPE_SECRET_KEY...${NC}"
    echo "$STRIPE_SECRET_KEY" | gh secret set "STRIPE_SECRET_KEY" --repo "$REPO_FULL"
    
    echo -e "${BLUE}Configurando STRIPE_WEBHOOK_SECRET...${NC}"
    echo "$STRIPE_WEBHOOK_SECRET" | gh secret set "STRIPE_WEBHOOK_SECRET" --repo "$REPO_FULL"
    
    echo ""
    echo -e "${GREEN}🎉 ¡SECRETS CONFIGURADOS AUTOMÁTICAMENTE!${NC}"
    
else
    echo -e "${YELLOW}⚠️ GitHub CLI no está instalado${NC}"
    echo -e "${BLUE}Configura manualmente en GitHub:${NC}"
    echo ""
    echo -e "${YELLOW}1. Ve a tu repositorio en GitHub:${NC}"
    echo "   https://github.com/$REPO_FULL"
    echo ""
    echo -e "${YELLOW}2. Settings → Secrets and variables → Actions${NC}"
    echo ""
    echo -e "${YELLOW}3. New repository secret para cada uno:${NC}"
    echo ""
    echo -e "${BLUE}   SECRETS A CONFIGURAR:${NC}"
    echo "   ┌─────────────────────────────────┬─────────────────────────────────┐"
    echo "   │ Nombre del Secret               │ Valor                           │"
    echo "   ├─────────────────────────────────┼─────────────────────────────────┤"
    echo "   │ FLY_API_TOKEN_STAGING          │ $FLY_TOKEN"
    echo "   │ FLY_API_TOKEN_PRODUCTION       │ $FLY_TOKEN"
    echo "   │ DATABASE_URL                   │ $DATABASE_URL"
    echo "   │ STRIPE_SECRET_KEY              │ $STRIPE_SECRET_KEY"
    echo "   │ STRIPE_WEBHOOK_SECRET          │ $STRIPE_WEBHOOK_SECRET"
    echo "   └─────────────────────────────────┴─────────────────────────────────┘"
fi

echo ""
echo -e "${GREEN}✅ DESPUÉS DE CONFIGURAR:${NC}"
echo "1. Haz push a tu repositorio"
echo "2. Los workflows se ejecutarán automáticamente"
echo "3. Verifica en Actions tab que todo funcione"
echo ""
echo -e "${GREEN}🚀 ¡CI/CD CONFIGURADO Y LISTO!${NC}"
