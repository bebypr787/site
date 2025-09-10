# ContenidosX v4 — Promos dinámicas (Supabase + Stripe)

Incluye:
- **Tablas** `banner_promos` y `sidebar_promos` + RLS (solo lectura pública de promos activas).
- **Endpoints Stripe** para comprar espacio: `/api/checkout/banner` y `/api/checkout/sidebar`.
- **Webhook** `/api/webhooks/stripe` que inserta automáticamente promos con vigencia **7 días**.
- **Feed** que **lee promos activas** vía `/api/promos` (SWR con refresco cada 30s).

## Setup rápido
1) `npm i`
2) Copia `.env.example` → `.env.local` y completa:
   - `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY` (solo servidor; **no exponer**)
   - `STRIPE_SECRET_KEY` y `STRIPE_WEBHOOK_SECRET`
3) En tu proyecto Supabase, corre `supabase/schema.sql` (Editor SQL).
4) En Stripe, crea un webhook a `<0> (evento `checkout.session.completed`).
5) `npm run dev` y visita `/feed`.

## Notas
- El webhook inserta promos con `avatar_url`/`cover_url` vacíos a modo demo. Podés completarlos con tu UI de creador o leyendo desde `creators` por `creator_id`.
- Para producción, validá que el **creador sea dueño del slot** y evita duplicados si ya tiene una promo activa.

¡Listo para conectar y cobrar! 🚀
## Panel de Creador (v5)
- Ruta: `/creator/dashboard`
- Acciones:
  - **Editar avatar/cover** (por URL) → `POST /api/creator/update`
  - **Estado de promoción** (banner/sidebar) → `GET /api/my/promos?creator_id=...`
  - **Comprar** espacios → botones que llaman `POST /api/checkout/banner` y `POST /api/checkout/sidebar` (Stripe)
- Inicialización demo: `GET /api/creator/init` crea un creador ficticio si no existe.
## Subidas (Supabase Storage) — v6
- Componente `components/UploadButton.tsx` permite subir **avatar** y **cover**.
- Bucket recomendado: **`creators`** con carpetas `avatars/` y `covers/`.
- Para demo, marca el bucket como **public** y usa `getPublicUrl`.
- En producción, usa **políticas de acceso** y/o URLs firmadas.

### Crear bucket y políticas (GUI o SQL)
1) Crea bucket `creators` (público para demo).
2) Opcional SQL de ejemplo para restricciones de tipo MIME e IDs (ajusta a tu modelo):
```sql
-- Ejemplo: solo imágenes y 5MB máx (válido si usas edge functions para validar)
-- Storage policies se manejan aparte de RLS de Postgres.
```text

## Panel del Fan — v6
- Ruta: `/fan/dashboard` con accesos rápidos a **bookmarks**, **suscripciones** y **métodos de pago**.
- Los detalles se gestionan en las páginas `/account/*` (placeholders listos para conectar).
## v7 — Storage privado con URLs firmadas + Bookmarks & Subscriptions (RLS)
### Storage (privado)
- Endpoints:
  - `POST /api/storage/sign-upload` → `createSignedUploadUrl(path)`
  - `POST /api/storage/sign-download` → `createSignedUrl(path, expires)`
- Cliente:
  - `components/UploadButtonSigned.tsx` usa `uploadToSignedUrl` y luego pide un **signed download URL** para previsualizar.
- Recomendación: marcar el bucket `creators` como **privado**.

### Bookmarks & Subscriptions
- Tablas: `fan_bookmarks`, `fan_subscriptions` con **RLS** por `auth.uid()`.
- APIs de demo (usa header `x-user-id` mientras no integremos JWT):
  - `GET/POST/DELETE /api/bookmarks`
  - `GET/POST/DELETE /api/subscriptions`
- En producción, lee `user_id` desde el **JWT** de Supabase en el middleware/API y elimina el header de demo.

### Siguientes pasos sugeridos
- Reemplazar `x-user-id` por autenticación real (Supabase Auth).
- Validar compras de suscripciones via **Stripe** (checkout + webhook) antes de insertar en `fan_subscriptions`.
- Añadir índice por `creator_id` para consultas rápidas y evitar duplicados activos.
## v9 — Suscripciones de fans con Stripe + Perfil público con botón “Suscribirse”
### Cambios clave
- **Checkout de suscripción**: `POST /api/checkout/subscription` (modo `subscription`, mensual).
- **Webhook** amplíado**: maneja `customer.subscription.created/updated/deleted` (requiere mapping Customer↔User y Product/Price↔Creator).
- **Estado per-creator**: `GET /api/my/sub-status?creator_id=...`.
- **Perfil público** (`/creator/[id]`): ahora muestra **botón Suscribirse** y estado **activo** si corresponde.

### Importante (mapping recomendado)
Para completar `fan_subscriptions` automáticamente en el webhook:
- Guarda `stripe_customer_id` en tu tabla de usuarios al crear el Customer.
- Guarda `creator_id` en `product.metadata.creator_id` al crear el producto/price.
- En el webhook, recupera `supabase_user_id` desde el Customer (via `metadata`) y `creator_id` desde el Product o Price para hacer el `upsert` confiable.

### Variables de entorno Stripe
- `STRIPE_SECRET_KEY` y `STRIPE_WEBHOOK_SECRET` deben estar configuradas.
## v11 — Paywall del feed + Lives con recordatorios + Analíticas
### Paywall del feed
- Nuevo endpoint `GET /api/my/subs-map` devuelve un mapa `{ creator_id: true }` con suscripciones activas del usuario.
- `components/PostList.tsx` usa ese mapa para **desenfocar** contenido premium y mostrar botón **Suscribirse** si no está suscrito.

### Lives con recordatorios
- Tablas: `live_events`, `live_reminders_sent` con RLS para servicio.
- Endpoints:
  - `POST /api/lives/create` (programar live).
  - `GET /api/lives/list` (listar próximos lives, opcional por `creator_id`).
  - `GET /api/cron/send-live-reminders` (para correr con cron/edge function) → envía emails 15 min antes a suscriptores activos.
- UI: `/creator/lives` para crear y listar lives.

### Analíticas del creador
- `GET /api/creator/analytics?creator_id=...` calcula:
  - **Subs activas**, **MRR aprox** (suma de `amount_cents`), **Banners activos**, **Sidebars activos**.
- UI: `/creator/analytics` muestra tarjetas con métricas.

> Nota: este build mantiene el **stub de email** (Resend opcional). Programa el endpoint de cron con un scheduler externo.
---
## v12 — Docker + Compose + Migraciones
### Docker
- **Dockerfile** multi-stage (builder + runner).
- **.dockerignore** para reducir contexto.
- `docker compose up -d` levanta el servicio en `http://localhost:3000`.

### Variables de entorno
Usa un archivo `.env` (o exporta en tu shell) con:
```text
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
STRIPE_SECRET_KEY=...
STRIPE_WEBHOOK_SECRET=...
RESEND_API_KEY=   # opcional
DATABASE_URL=     # para migraciones con psql
```text
Luego:
```text
docker compose up -d
```text

### Migraciones
- Carpeta `migrations/` con `v11.sql` (Lives + Reminders).
- Script `scripts/migrate.sh` que usa `psql` y `DATABASE_URL`.
```text
make migrate-v11
# o
make migrate-file file=migrations/v11.sql
```text

### Tips
- Para desarrollo con Stripe CLI (opcional), descomenta el servicio `stripe` del `docker-compose.yml`.
- El webhook de Stripe debe apuntar a: `/api/webhooks/stripe`.
---
## v13 — CI/CD con GitHub Actions + GHCR + Deploy opcional (Fly/Railway)
### Workflows
- `.github/workflows/ci.yml` → instala deps y **build** de Next.js.
- `.github/workflows/docker-ghcr.yml` → **build & push** de imagen a **GitHub Container Registry (GHCR)**.
- `.github/workflows/migrate.yml` → ejecuta **migraciones SQL** con `psql` (usa `secrets.DATABASE_URL`).
- `.github/workflows/deploy-fly.yml` → despliegue a **Fly.io** (usa `secrets.FLY_API_TOKEN`).
- `.github/workflows/deploy-railway.yml` → despliegue a **Railway** (usa `secrets.RAILWAY_TOKEN`).

### Secrets necesarios
- `DATABASE_URL` → cadena Postgres (Supabase → Project Settings → Database).
- `FLY_API_TOKEN` → si usas Fly.io.
- `RAILWAY_TOKEN` → si usas Railway.

### GHCR
La imagen se publica en `ghcr.io/<owner>/<repo>:<tag>` automáticamente al hacer push a `main`.

### Fly.io
1. Cambia `app` en `fly.toml` por el nombre de tu app.
2. Sube secrets de entorno en Fly (o usa variables en el panel).
3. Lanza manual o automáticamente el workflow de deploy.

### Railway
1. Crea un proyecto y servicio `contenidosx` (o ajusta el nombre en el workflow).
2. Configura las variables en Railway con las claves de Supabase/Stripe/Resend.
3. Ejecuta el workflow de deploy con `RAILWAY_TOKEN`.

> Si quieres, puedo ajustarte el **host de despliegue** que prefieras y dejar los workflows listos para tu repo.
---
## v14 — Entornos Staging/Production en Fly.io + Checklist
- Archivos separados: `fly.production.toml` y `fly.staging.toml`.
- Workflows:
  - `.github/workflows/deploy-fly-production.yml` (branch `main` → prod).
  - `.github/workflows/deploy-fly-staging.yml` (branch `dev` → stg).
- **Checklist** en `LAUNCH_CHECKLIST.md` con pasos de DNS, SSL, Stripe, Supabase, Emails y validación.

### Flujo recomendado
- `dev` → staging → `staging.contenidosx.com`.
- `main` → production → `contenidosx.com`.

Así puedes probar en staging antes de lanzar cambios a producción.
---
## v15 — Scripts de Bootstrap para Fly.io
### Scripts agregados
- `scripts/set_fly_secrets.sh` → carga **secrets** en Fly tomando variables desde un archivo `.env`.
  - Uso: `./scripts/set_fly_secrets.sh <fly_app> <env_file>`
  - Ej: `./scripts/set_fly_secrets.sh contenidosx-app-stg .env.staging`
- `scripts/bootstrap_fly.sh` → crea apps `contenidosx-app-stg` y `contenidosx-app-prod`, sube secrets (si existen `.env.staging` / `.env.production`) y realiza el **primer deploy** usando los TOML de cada entorno.

### Pasos
1. Crea y completa tus archivos `.env.staging` y `.env.production` (puedes basarte en los `*.example`).
2. Inicia sesión en Fly:
   ```bash
   flyctl auth login
   ```
3. Ejecuta:
   ```bash
   ./scripts/bootstrap_fly.sh
   ```
4. Verifica dominios/certificados en el dashboard de Fly (o con `flyctl certs list --app <app>`).

> Tip: si ya creaste las apps previamente, el script continúa sin romperse.
---
## v16 — Entrega personalizada (envs prellenados + rename rápido)
### Archivos nuevos
- `.env.staging` y `.env.production` con **plantillas rellenadas** (reemplaza con tus valores reales).
- `scripts/rename_apps.sh` para renombrar las apps de Fly en **1 comando**.

### Pasos exprés
1) Ajusta `.env.staging` y `.env.production` con tus claves reales.
2) (Opcional) Cambia nombres de apps de Fly:
   ```bash
   ./scripts/rename_apps.sh <mi-app-stg> <mi-app-prod>
   ```
3) Bootstrap staging/prod en Fly (si aún no lo hiciste):
   ```bash
   flyctl auth login
   ./scripts/bootstrap_fly.sh
   ```
4) Sube a GitHub y activa **workflows** (CI/CD, deploys, migraciones).
5) Verifica `/auth`, `/feed`, `/creator/[id]`, `/account/*` y Stripe webhooks.
---
## v17 — Configuración con dominios contenidosx.com
- Producción: <0>
- Staging: <0>

### Archivos ajustados
- `.env.production` → incluye `NEXT_PUBLIC_SITE_URL=<0>
- `.env.staging` → incluye `NEXT_PUBLIC_SITE_URL=<0>
- `fly.production.toml` → dominio `contenidosx.com`
- `fly.staging.toml` → dominio `staging.contenidosx.com`

### Stripe Webhooks
- Producción: `<0>
- Staging: `<0>

### DNS
- Apunta `contenidosx.com` a Fly (IPv4/IPv6 que te dé `flyctl ips allocate`).
- Crea un CNAME o A/AAAA para `staging.contenidosx.com` hacia Fly.

### SSL
- Crea certificados en Fly:
  ```bash
  flyctl certs create contenidosx.com --app contenidosx-app-prod
  flyctl certs create staging.contenidosx.com --app contenidosx-app-stg
  ```
---
## v18 — Scripts para IPs y Certificados en Fly
### Scripts nuevos
- `scripts/fly_dns_and_cert.sh <app> <dominio>`
  Asigna **IPv4/IPv6** (si faltan), sugiere **registros DNS** y crea el **certificado SSL** para el dominio.
- `scripts/setup_domains_all.sh`
  Ejecuta lo anterior para **producción** y **staging**:
  ```bash
  ./scripts/setup_domains_all.sh
  # Variables opcionales:
  # APP_PROD, APP_STG, DOMAIN_PROD, DOMAIN_STG
  ```

### Flujo recomendado
1) Despliega la app (v14+).
2) Ejecuta:
   ```bash
   flyctl auth login
   ./scripts/setup_domains_all.sh
   ```
3) Configura tus registros **DNS** según IPs mostradas.
4) Verifica certificado:
   ```bash
   flyctl certs show contenidosx.com --app contenidosx-app-prod
   flyctl certs show staging.contenidosx.com --app contenidosx-app-stg
   ```
---
## v19 — Listo para usar con subdominios de Fly (.fly.dev)
- **Sin dominio propio necesario**.
- Staging usará: `<0>
- Producción usará: `<0>

### Cambios clave
- `.env.staging` → `NEXT_PUBLIC_SITE_URL=<0>
- `.env.production` → `NEXT_PUBLIC_SITE_URL=<0>
- `fly.staging.toml` y `fly.production.toml` sin bloques de `[[http_service.domains]]` (Fly gestiona `.fly.dev` automáticamente).

### Webhooks Stripe (mientras no tengas dominio)
- Staging: `<0>
- Production: `<0>

Cuando compres **contenidosx.com**, vuelve a v17/v18 o ejecuta:
1) Ajusta `.env.*` con `NEXT_PUBLIC_SITE_URL` a tus dominios.
2) Añade `[[http_service.domains]]` en los TOML (o usa los scripts v18).
3) Corre `./scripts/setup_domains_all.sh` y actualiza DNS.
