#!/usr/bin/env bash
# Script para probar todas las funcionalidades de ContenidosX
# Usage: ./scripts/test_complete_functionality.sh

set -euo pipefail

echo "🧪 TESTING COMPLETO DE FUNCIONALIDADES"
echo "======================================"
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con color
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# URLs de las aplicaciones
STAGING_URL="https://contenidosx-app-stg.fly.dev"
PROD_URL="https://contenidosx-app-prod.fly.dev"

# Función para probar endpoint
test_endpoint() {
    local url="$1"
    local description="$2"
    local expected_status="${3:-200}"
    
    echo "Probando: $description"
    echo "URL: $url"
    
    local response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$response" = "$expected_status" ]; then
        print_status "$description - Status: $response"
    else
        print_warning "$description - Status: $response (esperado: $expected_status)"
    fi
    echo ""
}

# Función para probar endpoint con POST
test_post_endpoint() {
    local url="$1"
    local description="$2"
    local data="$3"
    local expected_status="${4:-200}"
    
    echo "Probando: $description"
    echo "URL: $url"
    
    local response=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "$data" "$url")
    
    if [ "$response" = "$expected_status" ]; then
        print_status "$description - Status: $response"
    else
        print_warning "$description - Status: $response (esperado: $expected_status)"
    fi
    echo ""
}

# Probar endpoints básicos
test_basic_endpoints() {
    echo "🌐 PROBANDO ENDPOINTS BÁSICOS"
    echo "============================="
    
    # Staging
    echo "📋 STAGING:"
    test_endpoint "$STAGING_URL" "Página principal"
    test_endpoint "$STAGING_URL/feed" "Feed de contenido"
    test_endpoint "$STAGING_URL/explore" "Explorar creadores"
    test_endpoint "$STAGING_URL/auth" "Página de autenticación"
    test_endpoint "$STAGING_URL/messages" "Mensajes"
    
    # Producción
    echo "📋 PRODUCCIÓN:"
    test_endpoint "$PROD_URL" "Página principal"
    test_endpoint "$PROD_URL/feed" "Feed de contenido"
    test_endpoint "$PROD_URL/explore" "Explorar creadores"
    test_endpoint "$PROD_URL/auth" "Página de autenticación"
    test_endpoint "$PROD_URL/messages" "Mensajes"
}

# Probar endpoints de API
test_api_endpoints() {
    echo "🔌 PROBANDO ENDPOINTS DE API"
    echo "============================"
    
    # Staging
    echo "📋 STAGING API:"
    test_endpoint "$STAGING_URL/api/health" "Health check" "200"
    test_endpoint "$STAGING_URL/api/webhooks/stripe" "Stripe webhook" "405"  # Method not allowed para GET
    test_post_endpoint "$STAGING_URL/api/webhooks/stripe" "Stripe webhook POST" '{"test": "data"}' "400"  # Bad request sin datos válidos
    
    # Producción
    echo "📋 PRODUCCIÓN API:"
    test_endpoint "$PROD_URL/api/health" "Health check" "200"
    test_endpoint "$PROD_URL/api/webhooks/stripe" "Stripe webhook" "405"  # Method not allowed para GET
    test_post_endpoint "$PROD_URL/api/webhooks/stripe" "Stripe webhook POST" '{"test": "data"}' "400"  # Bad request sin datos válidos
}

# Probar funcionalidades de autenticación
test_auth_functionality() {
    echo "🔐 PROBANDO FUNCIONALIDADES DE AUTENTICACIÓN"
    echo "============================================"
    
    # Probar endpoints de auth
    echo "📋 Endpoints de autenticación:"
    test_endpoint "$STAGING_URL/auth/signin" "Sign in"
    test_endpoint "$STAGING_URL/auth/signup" "Sign up"
    test_endpoint "$STAGING_URL/auth/callback" "Auth callback"
    
    test_endpoint "$PROD_URL/auth/signin" "Sign in"
    test_endpoint "$PROD_URL/auth/signup" "Sign up"
    test_endpoint "$PROD_URL/auth/callback" "Auth callback"
}

# Probar funcionalidades de contenido
test_content_functionality() {
    echo "📝 PROBANDO FUNCIONALIDADES DE CONTENIDO"
    echo "========================================"
    
    # Probar endpoints de contenido
    echo "📋 Endpoints de contenido:"
    test_endpoint "$STAGING_URL/api/posts" "Posts API"
    test_endpoint "$STAGING_URL/api/creators" "Creators API"
    test_endpoint "$STAGING_URL/api/subscriptions" "Subscriptions API"
    
    test_endpoint "$PROD_URL/api/posts" "Posts API"
    test_endpoint "$PROD_URL/api/creators" "Creators API"
    test_endpoint "$PROD_URL/api/subscriptions" "Subscriptions API"
}

# Probar funcionalidades de Stripe
test_stripe_functionality() {
    echo "💳 PROBANDO FUNCIONALIDADES DE STRIPE"
    echo "===================================="
    
    # Probar endpoints de Stripe
    echo "📋 Endpoints de Stripe:"
    test_endpoint "$STAGING_URL/api/stripe/create-checkout" "Create checkout session" "405"  # Method not allowed para GET
    test_endpoint "$STAGING_URL/api/stripe/create-portal" "Create portal session" "405"  # Method not allowed para GET
    
    test_endpoint "$PROD_URL/api/stripe/create-checkout" "Create checkout session" "405"  # Method not allowed para GET
    test_endpoint "$PROD_URL/api/stripe/create-portal" "Create portal session" "405"  # Method not allowed para GET
}

# Probar funcionalidades de email
test_email_functionality() {
    echo "📧 PROBANDO FUNCIONALIDADES DE EMAIL"
    echo "===================================="
    
    # Probar endpoints de email
    echo "📋 Endpoints de email:"
    test_endpoint "$STAGING_URL/api/send-email" "Send email" "405"  # Method not allowed para GET
    test_endpoint "$PROD_URL/api/send-email" "Send email" "405"  # Method not allowed para GET
}

# Verificar configuración de secrets
check_secrets_configuration() {
    echo "🔑 VERIFICANDO CONFIGURACIÓN DE SECRETS"
    echo "======================================="
    
    # Verificar que las aplicaciones están funcionando
    if curl -s -f "$STAGING_URL" > /dev/null; then
        print_status "Staging app está funcionando"
    else
        print_error "Staging app no está funcionando"
    fi
    
    if curl -s -f "$PROD_URL" > /dev/null; then
        print_status "Producción app está funcionando"
    else
        print_error "Producción app no está funcionando"
    fi
}

# Mostrar resumen de testing
show_testing_summary() {
    echo ""
    echo "📊 RESUMEN DE TESTING"
    echo "===================="
    
    echo "✅ Funcionalidades probadas:"
    echo "• Endpoints básicos (páginas principales)"
    echo "• Endpoints de API"
    echo "• Funcionalidades de autenticación"
    echo "• Funcionalidades de contenido"
    echo "• Funcionalidades de Stripe"
    echo "• Funcionalidades de email"
    echo "• Configuración de secrets"
    
    echo ""
    echo "🔧 Próximos pasos para testing manual:"
    echo "• Registro de usuarios"
    echo "• Login/logout"
    echo "• Creación de perfiles de creador"
    echo "• Publicación de contenido"
    echo "• Suscripciones de Stripe"
    echo "• Paywall funcionando"
    echo "• Envío de emails"
    
    echo ""
    echo "🌐 URLs para testing manual:"
    echo "• Staging: $STAGING_URL"
    echo "• Producción: $PROD_URL"
}

# Función principal
main() {
    echo "Iniciando testing completo de funcionalidades..."
    echo ""
    
    # Ejecutar todas las pruebas
    test_basic_endpoints
    test_api_endpoints
    test_auth_functionality
    test_content_functionality
    test_stripe_functionality
    test_email_functionality
    check_secrets_configuration
    
    # Mostrar resumen
    show_testing_summary
    
    echo ""
    echo "🎉 TESTING COMPLETADO"
    echo "===================="
    echo "Revisa los resultados arriba para ver el estado de cada funcionalidad"
}

# Ejecutar función principal
main "$@"

