# 💳 Guía de Configuración de Stripe

## 🎯 **Configuración de Stripe para ContenidosX**

Esta guía te ayudará a configurar Stripe para manejar suscripciones y pagos en ContenidosX.

---

## 📋 **Paso 1: Crear Cuenta de Stripe**

1. Ve a <0>
2. Crea una cuenta o inicia sesión
3. Completa la verificación de tu cuenta
4. Activa el modo test para desarrollo

---

## 🔑 **Paso 2: Obtener Claves de API**

### **Modo Test (Staging):**
1. Ve a <0>
2. Copia la **Publishable key** (pk_test_...)
3. Copia la **Secret key** (sk_test_***HIDDEN***...)

### **Modo Live (Producción):**
1. Ve a <0>
2. Copia la **Publishable key** (pk_live_...)
3. Copia la **Secret key** (sk_live_...)

---

## 🔗 **Paso 3: Configurar Webhooks**

### **Staging Webhook:**
1. Ve a <0>
2. Haz clic en **Add endpoint**
3. **URL:** `<0>
4. **Eventos a escuchar:**
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`
5. Copia el **Signing secret** (whsec_...)

### **Producción Webhook:**
1. Ve a <0>
2. Haz clic en **Add endpoint**
3. **URL:** `<0>
4. **Eventos a escuchar:** (mismos que staging)
5. Copia el **Signing secret** (whsec_...)

---

## 🛠️ **Paso 4: Actualizar Variables de Entorno**

### **Archivo .env.staging:**
```bash
# Stripe Configuration (Test Mode)
STRIPE_SECRET_KEY=sk_test_***HIDDEN***[tu_clave_secreta_test]
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_[tu_clave_publica_test]
STRIPE_WEBHOOK_SECRET=whsec_[tu_webhook_secret_test]
```text

### **Archivo .env.production:**
```bash
# Stripe Configuration (Live Mode)
STRIPE_SECRET_KEY=sk_live_[tu_clave_secreta_live]
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_[tu_clave_publica_live]
STRIPE_WEBHOOK_SECRET=whsec_[tu_webhook_secret_live]
```text

---

## 🚀 **Paso 5: Actualizar Secrets en Fly.io**

```bash
# Staging
./scripts/set_fly_secrets.sh contenidosx-app-stg .env.staging

# Producción
./scripts/set_fly_secrets.sh contenidosx-app-prod .env.production
```text

---

## 🧪 **Paso 6: Testing**

### **Tarjetas de Prueba (Modo Test):**
- **Éxito:** `4242 4242 4242 4242`
- **Declinada:** `4000 0000 0000 0002`
- **Requiere autenticación:** `4000 0025 0000 3155`

### **Probar Flujo:**
1. Ve a <0>
2. Navega a una página de suscripción
3. Usa una tarjeta de prueba
4. Verifica que el webhook recibe el evento

---

## 📊 **Paso 7: Monitoreo**

### **Dashboard de Stripe:**
- **Test:** <0>
- **Live:** <0>

### **Logs de Webhooks:**
- Ve a Webhooks → [Tu endpoint] → Logs
- Verifica que los eventos se reciben correctamente

---

## 🔧 **Configuración Avanzada**

### **Productos y Precios:**
1. Ve a Products en el dashboard de Stripe
2. Crea productos para tus suscripciones
3. Configura precios recurrentes
4. Usa los IDs de precio en tu aplicación

### **Configuración de Impuestos:**
1. Ve a Settings → Tax
2. Configura las tasas de impuestos
3. Habilita el cálculo automático

---

## 🚨 **Consideraciones de Seguridad**

- **Nunca** expongas las claves secretas en el frontend
- **Siempre** usa HTTPS para webhooks
- **Valida** las firmas de webhook
- **Maneja** errores de pago apropiadamente

---

## 📝 **Ejemplo de Uso en Código**

```typescript
// lib/stripe.ts
import Stripe from 'stripe';

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
});

// Crear sesión de checkout
export async function createCheckoutSession(priceId: string, customerId: string) {
  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    payment_method_types: ['card'],
    line_items: [
      {
        price: priceId,
        quantity: 1,
      },
    ],
    mode: 'subscription',
    success_url: `${process.env.NEXT_PUBLIC_APP_URL}/success`,
    cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/cancel`,
  });

  return session;
}
```text

---

## ✅ **Checklist de Configuración**

- [ ] Cuenta de Stripe creada
- [ ] Claves de API obtenidas (test y live)
- [ ] Webhooks configurados
- [ ] Variables de entorno actualizadas
- [ ] Secrets actualizados en Fly.io
- [ ] Testing con tarjetas de prueba
- [ ] Monitoreo configurado

---

*Guía creada para ContenidosX - 10 de septiembre de 2025*
