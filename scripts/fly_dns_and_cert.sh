#!/usr/bin/env bash
# Automatiza IPs + certificados SSL para una app Fly y dominio dado.
# Uso:
#   ./scripts/fly_dns_and_cert.sh <fly_app> <domain>
# Ejemplo:
#   ./scripts/fly_dns_and_cert.sh contenidosx-app-prod contenidosx.com
set -euo pipefail

if ! command -v flyctl >/dev/null 2>&1; then
  echo "Error: flyctl no está instalado. Instala con: https://fly.io/docs/hands-on/install-flyctl/"
  exit 1
fi

if [ $# -lt 2 ]; then
  echo "Uso: $0 <fly_app> <domain>"
  exit 1
fi

APP="$1"
DOMAIN="$2"

echo "==> App: $APP | Dominio: $DOMAIN"

# 1) Asignar IPs si no existen
echo "==> Verificando IPs existentes..."
EXISTING_IPS=$(flyctl ips list --app "$APP" 2>/dev/null || true)
if ! echo "$EXISTING_IPS" | grep -q "v4"; then
  echo "==> Asignando IPv4..."
  flyctl ips allocate-v4 --app "$APP"
fi
if ! echo "$EXISTING_IPS" | grep -q "v6"; then
  echo "==> Asignando IPv6..."
  flyctl ips allocate-v6 --app "$APP"
fi

echo "==> IPs actuales:"
flyctl ips list --app "$APP" || true

# 2) Crear certificado (si no existe)
EXISTS=$(flyctl certs list --app "$APP" | awk '{print $1}' | grep -Fx "$DOMAIN" || true)
if [ -z "$EXISTS" ]; then
  echo "==> Creando certificado para $DOMAIN ..."
  flyctl certs create "$DOMAIN" --app "$APP"
else
  echo "==> Certificado ya registrado para $DOMAIN"
fi

echo ""
echo "==> Registros DNS recomendados (usa A/AAAA o CNAME según tu DNS):"
flyctl ips list --app "$APP" || true
echo ""
echo "==> Estado de certificado:"
flyctl certs show "$DOMAIN" --app "$APP" || true

# 3) Esperar verificación (opcional)
echo ""
echo "Puedes verificar periódicamente con:"
echo "  flyctl certs show $DOMAIN --app $APP"
echo "Una vez DNS apunte correctamente, el certificado pasará a 'Ready'."
