#!/usr/bin/env bash
# Script para configurar todo el proyecto ContenidosX
# Usage: ./scripts/configurar_todo.sh

set -euo pipefail

echo "🚀 CONFIGURACIÓN COMPLETA DE CONTENIDOSX"
echo "========================================"
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

# Verificar que flyctl está instalado
check_flyctl() {
    if ! command -v flyctl &> /dev/null; then
        print_error "flyctl no está instalado"
        echo "Instalando flyctl..."
        curl -L https://fly.io/install.sh | sh
        export PATH="$HOME/.fly/bin:$PATH"
    fi
    print_status "flyctl está disponible"
}

# Verificar que estamos autenticados en Fly.io
check_fly_auth() {
    if ! flyctl auth whoami &> /dev/null; then
        print_warning "No estás autenticado en Fly.io"
        echo "Iniciando autenticación..."
        flyctl auth login
    fi
    print_status "Autenticado en Fly.io"
}

# Verificar estado de las aplicaciones
check_apps_status() {
    echo ""
    echo "📊 VERIFICANDO ESTADO DE APLICACIONES"
    echo "====================================="
    
    # Staging
    if flyctl status --app contenidosx-app-stg &> /dev/null; then
        print_status "Staging app está funcionando"
        echo "   URL: https://contenidosx-app-stg.fly.dev"
    else
        print_error "Staging app no está funcionando"
    fi
    
    # Producción
    if flyctl status --app contenidosx-app-prod &> /dev/null; then
        print_status "Producción app está funcionando"
        echo "   URL: https://contenidosx-app-prod.fly.dev"
    else
        print_error "Producción app no está funcionando"
    fi
}

# Verificar secrets configurados
check_secrets() {
    echo ""
    echo "🔑 VERIFICANDO SECRETS CONFIGURADOS"
    echo "==================================="
    
    # Staging secrets
    echo "📋 Secrets en STAGING:"
    if flyctl secrets list --app contenidosx-app-stg | grep -q "RESEND_API_KEY"; then
        print_status "RESEND_API_KEY configurado en staging"
    else
        print_warning "RESEND_API_KEY no configurado en staging"
    fi
    
    # Producción secrets
    echo "📋 Secrets en PRODUCCIÓN:"
    if flyctl secrets list --app contenidosx-app-prod | grep -q "RESEND_API_KEY"; then
        print_status "RESEND_API_KEY configurado en producción"
    else
        print_warning "RESEND_API_KEY no configurado en producción"
    fi
}

# Probar conectividad de las aplicaciones
test_connectivity() {
    echo ""
    echo "🌐 PROBANDO CONECTIVIDAD"
    echo "========================"
    
    # Staging
    echo "Probando STAGING..."
    if curl -s -f https://contenidosx-app-stg.fly.dev > /dev/null; then
        print_status "Staging responde correctamente"
    else
        print_error "Staging no responde"
    fi
    
    # Producción
    echo "Probando PRODUCCIÓN..."
    if curl -s -f https://contenidosx-app-prod.fly.dev > /dev/null; then
        print_status "Producción responde correctamente"
    else
        print_error "Producción no responde"
    fi
}

# Mostrar información de configuración
show_config_info() {
    echo ""
    echo "📋 INFORMACIÓN DE CONFIGURACIÓN"
    echo "==============================="
    
    echo "🔧 URLs de las aplicaciones:"
    echo "   • Staging: https://contenidosx-app-stg.fly.dev"
    echo "   • Producción: https://contenidosx-app-prod.fly.dev"
    
    echo ""
    echo "🔑 Webhooks de Stripe:"
    echo "   • Staging: https://contenidosx-app-stg.fly.dev/api/webhooks/stripe"
    echo "   • Producción: https://contenidosx-app-prod.fly.dev/api/webhooks/stripe"
    
    echo ""
    echo "🔐 URLs de autenticación:"
    echo "   • Staging: https://contenidosx-app-stg.fly.dev/auth"
    echo "   • Producción: https://contenidosx-app-prod.fly.dev/auth"
    
    echo ""
    echo "📧 Configuración de email:"
    echo "   • Resend API configurado en ambos entornos"
    echo "   • Staging: re_tu_api_key_aqui (reemplazar con clave real)"
    echo "   • Producción: re_i3JdqKg6_3Tuc6YuiRXvThy3BiCGbMnsD"
}

# Mostrar próximos pasos
show_next_steps() {
    echo ""
    echo "🎯 PRÓXIMOS PASOS"
    echo "================="
    
    echo "1. 🔑 Configurar GitHub Secrets:"
    echo "   • Ve a tu repositorio en GitHub"
    echo "   • Settings → Secrets and variables → Actions"
    echo "   • Agrega los secrets listados en CONFIGURACION_COMPLETA_GUIA.md"
    
    echo ""
    echo "2. 💳 Configurar webhooks de Stripe:"
    echo "   • Ve a https://dashboard.stripe.com/webhooks"
    echo "   • Crea webhooks para staging y producción"
    echo "   • Configura los eventos necesarios"
    
    echo ""
    echo "3. 🔐 Configurar autenticación de Supabase:"
    echo "   • Ve a https://supabase.com/dashboard/project/hojusdfclfrovxroumff"
    echo "   • Authentication → Settings"
    echo "   • Configura URLs de redirección"
    
    echo ""
    echo "4. 🧪 Probar funcionalidades:"
    echo "   • Registro de usuarios"
    echo "   • Login/logout"
    echo "   • Creación de contenido"
    echo "   • Suscripciones de Stripe"
    echo "   • Paywall funcionando"
    
    echo ""
    echo "5. 📊 Monitorear aplicaciones:"
    echo "   • Staging: https://fly.io/apps/contenidosx-app-stg/monitoring"
    echo "   • Producción: https://fly.io/apps/contenidosx-app-prod/monitoring"
}

# Función principal
main() {
    echo "Iniciando verificación completa del proyecto..."
    echo ""
    
    # Verificaciones básicas
    check_flyctl
    check_fly_auth
    
    # Verificar estado de las aplicaciones
    check_apps_status
    
    # Verificar secrets
    check_secrets
    
    # Probar conectividad
    test_connectivity
    
    # Mostrar información de configuración
    show_config_info
    
    # Mostrar próximos pasos
    show_next_steps
    
    echo ""
    echo "🎉 VERIFICACIÓN COMPLETADA"
    echo "=========================="
    echo "Revisa CONFIGURACION_COMPLETA_GUIA.md para más detalles"
}

# Ejecutar función principal
main "$@"

