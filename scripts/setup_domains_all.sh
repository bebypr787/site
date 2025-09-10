#!/usr/bin/env bash
# Configura dominios e IPs para producción y staging usando nombres por defecto.
# Uso:
#   ./scripts/setup_domains_all.sh
# Variables (opcional, override):
#   APP_PROD, APP_STG, DOMAIN_PROD, DOMAIN_STG
set -euo pipefail

APP_PROD="${APP_PROD:-contenidosx-app-prod}"
APP_STG="${APP_STG:-contenidosx-app-stg}"
DOMAIN_PROD="${DOMAIN_PROD:-contenidosx.com}"
DOMAIN_STG="${DOMAIN_STG:-staging.contenidosx.com}"

echo "==> Producción: $APP_PROD / $DOMAIN_PROD"
./scripts/fly_dns_and_cert.sh "$APP_PROD" "$DOMAIN_PROD"

echo ""
echo "==> Staging: $APP_STG / $DOMAIN_STG"
./scripts/fly_dns_and_cert.sh "$APP_STG" "$DOMAIN_STG"

echo ""
echo "Listo. Apunta los DNS a las IPs mostradas arriba y verifica:"
echo "  flyctl certs show $DOMAIN_PROD --app $APP_PROD"
echo "  flyctl certs show $DOMAIN_STG --app $APP_STG"
