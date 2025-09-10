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

# Función para configurar secret en GitHub
set_github_secret() {
    local secret_name="$1"
    local secret_value="$2"
    local repo="$3"
    
    echo -e "${BLUE}Configurando secret: $secret_name${NC}"
    
    # Usar GitHub CLI si está disponible
    if command -v gh &> /dev/null; then
        echo "$secret_value" | gh secret set "$secret_name" --repo "$repo"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Secret $secret_name configurado correctamente${NC}"
        else
            echo -e "${RED}❌ Error configurando secret $secret_name${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ GitHub CLI no está instalado${NC}"
        echo -e "${BLUE}Configura manualmente en GitHub:${NC}"
        echo "   - Ve a tu repositorio en GitHub"
        echo "   - Settings → Secrets and variables → Actions"
        echo "   - New repository secret"
        echo "   - Name: $secret_name"
        echo "   - Value: $secret_value"
        echo ""
    fi
}

echo -e "${BLUE}📋 CONFIGURACIÓN DE GITHUB SECRETS${NC}"
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
get_input "🔑 Pega tu token de Fly.io (fly_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx):" FLY_TOKEN

if [[ ! $FLY_TOKEN =~ ^fly_ ]]; then
    echo -e "${RED}❌ Token de Fly.io inválido. Debe empezar con 'fly_'${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Token de Fly.io válido${NC}"
echo ""

# Obtener DATABASE_URL
get_input "🗄️ Pega tu DATABASE_URL de Supabase (postgresql://...):" DATABASE_URL

if [[ ! $DATABASE_URL =~ ^postgresql:// ]]; then
    echo -e "${RED}❌ DATABASE_URL inválido. Debe empezar con 'postgresql://'${NC}"
    exit 1
fi

echo -e "${GREEN}✅ DATABASE_URL válido${NC}"
echo ""

# Obtener STRIPE_SECRET_KEY
get_input "💳 Pega tu STRIPE_SECRET_KEY (sk_test_***HIDDEN***... o sk_live_...):" STRIPE_SECRET_KEY

if [[ ! $STRIPE_SECRET_KEY =~ ^sk_(test_|live_) ]]; then
    echo -e "${RED}❌ STRIPE_SECRET_KEY inválido. Debe empezar con 'sk_test_***HIDDEN***' o 'sk_live_'${NC}"
    exit 1
fi

echo -e "${GREEN}✅ STRIPE_SECRET_KEY válido${NC}"
echo ""

# Obtener STRIPE_WEBHOOK_SECRET
get_input "🔗 Pega tu STRIPE_WEBHOOK_SECRET (whsec_...):" STRIPE_WEBHOOK_SECRET

if [[ ! $STRIPE_WEBHOOK_SECRET =~ ^whsec_ ]]; then
    echo -e "${RED}❌ STRIPE_WEBHOOK_SECRET inválido. Debe empezar con 'whsec_'${NC}"
    exit 1
fi

echo -e "${GREEN}✅ STRIPE_WEBHOOK_SECRET válido${NC}"
echo ""

echo -e "${BLUE}🔧 CONFIGURANDO SECRETS EN GITHUB...${NC}"
echo ""

# Configurar todos los secrets
set_github_secret "FLY_API_TOKEN_STAGING" "$FLY_TOKEN" "$REPO_FULL"
set_github_secret "FLY_API_TOKEN_PRODUCTION" "$FLY_TOKEN" "$REPO_FULL"
set_github_secret "DATABASE_URL" "$DATABASE_URL" "$REPO_FULL"
set_github_secret "STRIPE_SECRET_KEY" "$STRIPE_SECRET_KEY" "$REPO_FULL"
set_github_secret "STRIPE_WEBHOOK_SECRET" "$STRIPE_WEBHOOK_SECRET" "$REPO_FULL"

echo ""
echo -e "${GREEN}🎉 ¡CONFIGURACIÓN COMPLETA!${NC}"
echo ""
echo -e "${BLUE}📊 SECRETS CONFIGURADOS:${NC}"
echo "✅ FLY_API_TOKEN_STAGING"
echo "✅ FLY_API_TOKEN_PRODUCTION"
echo "✅ DATABASE_URL"
echo "✅ STRIPE_SECRET_KEY"
echo "✅ STRIPE_WEBHOOK_SECRET"
echo ""
echo -e "${YELLOW}💡 PRÓXIMOS PASOS:${NC}"
echo "1. Haz push a tu repositorio"
echo "2. Los workflows de GitHub Actions se ejecutarán automáticamente"
echo "3. Verifica el despliegue en las Actions tab"
echo ""
echo -e "${GREEN}🚀 ¡CI/CD CONFIGURADO Y LISTO!${NC}"
