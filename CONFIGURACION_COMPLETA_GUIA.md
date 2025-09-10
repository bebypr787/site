# 🚀 Guía Completa de Configuración - ContenidosX

## 📋 **Estado Actual del Proyecto**

### ✅ **Completado:**
- ✅ Proyecto desplegado en Fly.io (staging y producción)
- ✅ RESEND_API_KEY configurado en ambos entornos
- ✅ Aplicaciones funcionando correctamente
- ✅ Dockerfile y configuración de build optimizada
- ✅ GitHub Actions workflows configurados

### 🔧 **Pendiente de Configuración:**

## 1. 🔑 **GitHub Secrets**

### **Configurar en GitHub:**
1. Ve a tu repositorio en GitHub
2. Settings → Secrets and variables → Actions
3. Agrega los siguientes secrets:

#### **Secrets para STAGING:**
```text
FLY_API_TOKEN_STAGING=fm2_lJPECAAAAAAACgXBxBCufxgq2BltYQ4na+7PunBHwrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABNZjx8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwEwy1SBmz8ayT/SEhDAc3hunWyi0hjyhs02WGHwu2+nuglLahqK84waeOeTMBGrh/DvgwxmwG1CJrSqEDETuVs4OrZGy4fo5hZh9k4kSZ7NjSBvUQk5DOA3gUS969Li3X0H5Y/KrugXsskadYILqvjDaN8uZP39h7FQcyBHMdz/ePgAPMZ/HqNw6fxOcQgaVYE9wuLZs+xC7PENr6q0ttNLqRTeRWZn5lqK0+esz8=

DATABASE_URL_STAGING=postgresql://postgres:password@localhost:5432/contenidosx_staging

STRIPE_SECRET_KEY_STAGING=sk_test_***HIDDEN***

STRIPE_WEBHOOK_SECRET_STAGING=whsec_dummy_webhook_secret_for_staging

RESEND_API_KEY_STAGING=re_tu_api_key_aqui
```text

#### **Secrets para PRODUCCIÓN:**
```text
FLY_API_TOKEN_PRODUCTION=fm2_lJPECAAAAAAACgXBxBCufxgq2BltYQ4na+7PunBHwrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABNZjx8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwEwy1SBmz8ayT/SEhDAc3hunWyi0hjyhs02WGHwu2+nuglLahqK84waeOeTMBGrh/DvgwxmwG1CJrSqEDETuVs4OrZGy4fo5hZh9k4kSZ7NjSBvUQk5DOA3gUS969Li3X0H5Y/KrugXsskadYILqvjDaN8uZP39h7FQcyBHMdz/ePgAPMZ/HqNw6fxOcQgaVYE9wuLZs+xC7PENr6q0ttNLqRTeRWZn5lqK0+esz8=

DATABASE_URL_PRODUCTION=postgresql://postgres:password@localhost:5432/contenidosx_production

STRIPE_SECRET_KEY_PRODUCTION=sk_live_dummy_stripe_secret_key_for_production

STRIPE_WEBHOOK_SECRET_PRODUCTION=whsec_dummy_webhook_secret_for_production

RESEND_API_KEY_PRODUCTION=re_i3JdqKg6_3Tuc6YuiRXvThy3BiCGbMnsD
```text

## 2. 💳 **Configuración de Stripe**

### **Webhooks a configurar:**

#### **STAGING:**
- URL: `<0>
- Eventos:
  - `customer.subscription.created`
  - `customer.subscription.updated`
  - `customer.subscription.deleted`
  - `invoice.payment_succeeded`
  - `invoice.payment_failed`

#### **PRODUCCIÓN:**
- URL: `<0>
- Eventos: (mismos que staging)

### **Pasos:**
1. Ve a <0>
2. Crea webhook para staging (modo test)
3. Crea webhook para producción (modo live)
4. Copia los webhook secrets y actualiza los archivos .env

## 3. 🔐 **Configuración de Supabase**

### **URLs de redirección:**
1. Ve a <0>
2. Authentication → Settings
3. Site URL: `<0>
4. Redirect URLs:
   - `<0>
   - `<0>

### **Configuración de email:**
- Templates personalizados
- SMTP settings
- Email verification

## 4. 📧 **Configuración de Resend**

### **API Keys configuradas:**
- **Staging**: `re_tu_api_key_aqui` (reemplazar con clave real)
- **Producción**: `re_i3JdqKg6_3Tuc6YuiRXvThy3BiCGbMnsD` ✅

### **Dominios verificados:**
- Configurar dominio personalizado en Resend
- Verificar DNS records

## 5. 🗄️ **Base de Datos**

### **Configuración actual:**
- **Staging**: `postgresql://postgres:password@localhost:5432/contenidosx_staging`
- **Producción**: `postgresql://postgres:password@localhost:5432/contenidosx_production`

### **Próximos pasos:**
1. Configurar base de datos real en Fly.io
2. Migrar esquemas
3. Configurar backups

## 6. 🧪 **Testing Completo**

### **Endpoints a probar:**
- ✅ `/` - Página principal
- ✅ `/feed` - Feed de contenido
- ✅ `/explore` - Explorar creadores
- ✅ `/auth` - Autenticación
- ✅ `/api/webhooks/stripe` - Webhooks de Stripe

### **Funcionalidades a probar:**
- [ ] Registro de usuarios
- [ ] Login/logout
- [ ] Creación de perfiles de creador
- [ ] Publicación de contenido
- [ ] Suscripciones de Stripe
- [ ] Paywall funcionando
- [ ] Envío de emails

## 7. 🚀 **Deploy y CI/CD**

### **Workflows configurados:**
- ✅ `deploy-fly.yml` - Deploy general
- ✅ `deploy-fly-staging.yml` - Deploy a staging
- ✅ `deploy-fly-production.yml` - Deploy a producción

### **Triggers:**
- Push a `main` → Deploy a producción
- Push a `staging` → Deploy a staging
- Pull request → Build y test

## 8. 📊 **Monitoreo**

### **URLs de monitoreo:**
- **Staging**: <0>
- **Producción**: <0>

### **Métricas a monitorear:**
- CPU y memoria
- Requests por segundo
- Tiempo de respuesta
- Errores 4xx/5xx
- Logs de aplicación

## 9. 🔒 **Seguridad**

### **Configuraciones de seguridad:**
- ✅ Secrets en Fly.io
- ✅ Variables de entorno seguras
- [ ] Rate limiting
- [ ] CORS configurado
- [ ] HTTPS habilitado
- [ ] Headers de seguridad

## 10. 📈 **Optimización**

### **Performance:**
- ✅ Docker multi-stage build
- ✅ Next.js optimizado
- [ ] CDN para assets estáticos
- [ ] Caching strategies
- [ ] Database indexing
- [ ] Image optimization

---

## 🎯 **Próximos Pasos Prioritarios:**

1. **Configurar GitHub Secrets** (5 min)
2. **Configurar webhooks de Stripe** (10 min)
3. **Configurar autenticación de Supabase** (15 min)
4. **Probar flujo completo de usuario** (30 min)
5. **Configurar base de datos real** (20 min)

---

## 📞 **Soporte y Documentación:**

- **Fly.io**: <0>
- **Stripe**: <0>
- **Supabase**: <0>
- **Resend**: <0>
- **Next.js**: <0>

---

**Última actualización**: $(date)
**Estado**: 🟡 Configuración en progreso
