#!/usr/bin/env bash
# Uso: ./scripts/rename_apps.sh <staging_app_name> <production_app_name>
set -euo pipefail
if [ $# -lt 2 ]; then
  echo "Uso: $0 <staging_app> <production_app>"
  exit 1
fi
STG="$1"
PRD="$2"

# Reemplaza en TOMLs y workflows
sed -i.bak "s/contenidosx-app-stg/${STG}/g" fly.staging.toml .github/workflows/deploy-fly-staging.yml || true
sed -i.bak "s/contenidosx-app-prod/${PRD}/g" fly.production.toml .github/workflows/deploy-fly-production.yml || true

echo "Actualizado:"
echo "  - fly.staging.toml → app=${STG}"
echo "  - fly.production.toml → app=${PRD}"
echo "  - workflows Fly apuntan a ${STG} (stg) y ${PRD} (prod)"
