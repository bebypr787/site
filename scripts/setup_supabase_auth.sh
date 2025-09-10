#!/bin/bash

echo "🔐 CONFIGURACIÓN DE AUTENTICACIÓN DE SUPABASE"
echo "============================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 CONFIGURACIÓN REQUERIDA EN SUPABASE:${NC}"
echo ""

echo -e "${YELLOW}1. 🌐 URLS DE REDIRECCIÓN:${NC}"
echo "   Ve a: https://supabase.com/dashboard/project/hojusdfclfrovxroumff/auth/url-configuration"
echo ""
echo "   Agrega estas URLs:"
echo "   - https://contenidosx-app-stg.fly.dev/auth/callback"
echo "   - https://contenidosx-app-prod.fly.dev/auth/callback"
echo "   - http://localhost:3000/auth/callback (para desarrollo local)"
echo ""

echo -e "${YELLOW}2. 📧 CONFIGURACIÓN DE EMAIL:${NC}"
echo "   Ve a: https://supabase.com/dashboard/project/hojusdfclfrovxroumff/auth/templates"
echo ""
echo "   Configura:"
echo "   - Confirm signup template"
echo "   - Reset password template"
echo "   - Magic link template"
echo ""

echo -e "${YELLOW}3. 🔑 PROVEEDORES DE AUTENTICACIÓN:${NC}"
echo "   Ve a: https://supabase.com/dashboard/project/hojusdfclfrovxroumff/auth/providers"
echo ""
echo "   Configura:"
echo "   - Email (ya habilitado)"
echo "   - Google (opcional)"
echo "   - GitHub (opcional)"
echo ""

echo -e "${YELLOW}4. 🛡️ POLÍTICAS DE SEGURIDAD:${NC}"
echo "   Ve a: https://supabase.com/dashboard/project/hojusdfclfrovxroumff/auth/policies"
echo ""
echo "   Verifica que las políticas estén configuradas para:"
echo "   - users_profile (RLS habilitado)"
echo "   - fan_subscriptions (RLS habilitado)"
echo "   - posts (RLS habilitado)"
echo ""

echo -e "${GREEN}📋 CHECKLIST DE CONFIGURACIÓN:${NC}"
echo ""
echo "✅ URLs de redirección configuradas"
echo "✅ Templates de email configurados"
echo "✅ Proveedores de autenticación habilitados"
echo "✅ Políticas de seguridad configuradas"
echo ""

echo -e "${BLUE}🎯 PRÓXIMOS PASOS:${NC}"
echo "1. Configurar URLs de redirección"
echo "2. Configurar templates de email"
echo "3. Habilitar proveedores de autenticación"
echo "4. Verificar políticas de seguridad"
echo "5. Probar el flujo de autenticación"
echo ""
echo -e "${YELLOW}⚠️ IMPORTANTE:${NC}"
echo "- Asegúrate de usar las URLs exactas mostradas"
echo "- Verifica que las políticas RLS estén habilitadas"
echo "- Prueba el flujo completo de autenticación"
