#!/usr/bin/env bash
# Script para probar el deploy localmente antes de subir a Fly.io
# Uso: ./scripts/test_local_deploy.sh

set -euo pipefail

echo "🧪 Probando deploy local de ContenidosX..."

# 1) Verificar que el proyecto compila
echo "📦 Verificando compilación..."
npm run build

# 2) Verificar que el servidor inicia
echo "🚀 Probando servidor local..."
npm start &
SERVER_PID=$!

# Esperar un poco para que el servidor inicie
sleep 5

# Verificar que el servidor está corriendo
if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Servidor local funcionando correctamente"
else
    echo "❌ Error: Servidor local no responde"
    kill $SERVER_PID 2>/dev/null || true
    exit 1
fi

# Matar el servidor
kill $SERVER_PID 2>/dev/null || true

echo "✅ Deploy local exitoso!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Ve a https://fly.io/high-risk-unlock para verificar tu cuenta"
echo "2. Una vez verificado, ejecuta: ./scripts/setup_fly_manual.sh"
echo "3. Configura los secrets reales"
echo "4. ¡Tu app estará desplegada!"
