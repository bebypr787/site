# Guía de Despliegue - ContenidosX

## 🚀 Estado Actual del Proyecto

✅ **Completado:**
- Dependencias instaladas (`npm install`)
- Proyecto compila correctamente (`npm run build`)
- Archivos de entorno creados (`.env.staging` y `.env.production`)
- Configuración de Fly.io verificada (`fly.staging.toml` y `fly.production.toml`)
- Workflows de GitHub Actions configurados
- flyctl instalado

## 📋 Próximos Pasos

### 1. Configurar Fly.io

**Opción A: Login Manual**
```bash
# Abrir navegador y hacer login en <0>
# Luego ejecutar:
export PATH="$HOME/.fly/bin:$PATH"
flyctl auth login
```text

**Opción B: Usar Token de API**
```bash
# Obtener token desde <0>
export FLY_API_TOKEN="tu_token_aqui"
export PATH="$HOME/.fly/bin:$PATH"
```text

### 2. Ejecutar Bootstrap de Fly.io

```bash
# Asegúrate de estar logueado en Fly.io
export PATH="$HOME/.fly/bin:$PATH"
./scripts/bootstrap_fly.sh
```text

Esto creará:
- App de staging: `contenidosx-app-stg`
- App de producción: `contenidosx-app-prod`
- Configurará los secrets desde los archivos `.env`

### 3. Configurar Secrets de GitHub

Ve a tu repositorio en GitHub → Settings → Secrets and variables → Actions

**Secrets requeridos:**
```text
FLY_API_TOKEN=tu_fly_api_token
DATABASE_URL=postgresql://user:pass@host:port/db
STRIPE_SECRET_KEY=sk_test_***HIDDEN***... (staging) / sk_live_... (production)
STRIPE_WEBHOOK_SECRET=whsec_...
NEXT_PUBLIC_SUPABASE_URL=<0>
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```text

### 4. URLs de Despliegue

Una vez desplegado, las apps estarán disponibles en:
- **Staging:** <0>
- **Producción:** <0>

### 5. Configurar Webhooks de Stripe

**Staging:**
- URL: `<0>
- Eventos: `customer.subscription.created`, `customer.subscription.updated`, `customer.subscription.deleted`

**Producción:**
- URL: `<0>
- Eventos: `customer.subscription.created`, `customer.subscription.updated`, `customer.subscription.deleted`

### 6. Testing

1. **Login:** Verificar que `/auth` funciona
2. **Feed:** Confirmar que `/feed` muestra contenido
3. **Suscripciones:** Probar flujo de suscripción con Stripe test
4. **Paywall:** Verificar que el contenido premium requiere suscripción

## 🔧 Comandos Útiles

```bash
# Ver logs de staging
flyctl logs --app contenidosx-app-stg

# Ver logs de producción
flyctl logs --app contenidosx-app-prod

# Deploy manual a staging
flyctl deploy --config fly.staging.toml --remote-only

# Deploy manual a producción
flyctl deploy --config fly.production.toml --remote-only

# Ver status de las apps
flyctl status --app contenidosx-app-stg
flyctl status --app contenidosx-app-prod
```text

## 📝 Notas Importantes

- Los archivos `.env.staging` y `.env.production` contienen variables dummy para testing
- Reemplaza las variables dummy con valores reales antes del despliegue
- El proyecto usa Next.js 14.2.5 con Supabase y Stripe
- Los workflows de GitHub se activan automáticamente en push a `main` (prod) y `dev` (staging)
