# 🔐 Guía de Configuración de GitHub Secrets

## 📋 **Secrets Requeridos para CI/CD**

Para que los workflows de GitHub Actions funcionen correctamente, necesitas configurar los siguientes secrets en tu repositorio.

### **🔧 Cómo Configurar Secrets:**

1. Ve a tu repositorio en GitHub
2. Haz clic en **Settings** (Configuración)
3. En el menú lateral, haz clic en **Secrets and variables** → **Actions**
4. Haz clic en **New repository secret**
5. Agrega cada secret con su nombre y valor

---

## 🚀 **Secrets de Fly.io**

### **FLY_API_TOKEN**
```text
Nombre: FLY_API_TOKEN
Valor: [Tu token de API de Fly.io]
```text

**Cómo obtener el token:**
1. Ve a <0>
2. Haz clic en **Create Token**
3. Dale un nombre (ej: "ContenidosX CI/CD")
4. Copia el token generado

---

## 💳 **Secrets de Stripe (Opcional)**

### **STRIPE_SECRET_KEY_STAGING**
```text
Nombre: STRIPE_SECRET_KEY_STAGING
Valor: sk_test_***HIDDEN***[tu_clave_secreta_de_stripe_test]
```text

### **STRIPE_SECRET_KEY_PRODUCTION**
```text
Nombre: STRIPE_SECRET_KEY_PRODUCTION
Valor: sk_live_[tu_clave_secreta_de_stripe_live]
```text

### **STRIPE_WEBHOOK_SECRET_STAGING**
```text
Nombre: STRIPE_WEBHOOK_SECRET_STAGING
Valor: whsec_[tu_webhook_secret_de_staging]
```text

### **STRIPE_WEBHOOK_SECRET_PRODUCTION**
```text
Nombre: STRIPE_WEBHOOK_SECRET_PRODUCTION
Valor: whsec_[tu_webhook_secret_de_production]
```text

---

## 🗄️ **Secrets de Supabase (Ya Configurados)**

### **NEXT_PUBLIC_SUPABASE_URL**
```text
Nombre: NEXT_PUBLIC_SUPABASE_URL
Valor: <0>
```text

### **NEXT_PUBLIC_SUPABASE_ANON_KEY**
```text
Nombre: NEXT_PUBLIC_SUPABASE_ANON_KEY
Valor: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvanVzZGZjbGZyb3Z4cm91bWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNDkwMzAsImV4cCI6MjA3MTkyNTAzMH0.HlbnlmVbppY6gK71m-2ChNlDkgWnNE6OuTClMlE-1Sc
```text

### **SUPABASE_SERVICE_ROLE_KEY**
```text
Nombre: SUPABASE_SERVICE_ROLE_KEY
Valor: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvanVzZGZjbGZyb3Z4cm91bWZmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NjM0OTAzMCwiZXhwIjoyMDcxOTI1MDMwfQ.WxUXJQv_wqCbSUKAK_X2dEzuT-zO_OxPhMQbSKzsdag
```text

---

## 📧 **Secrets de Email (Opcional)**

### **SMTP_HOST**
```text
Nombre: SMTP_HOST
Valor: smtp.gmail.com
```text

### **SMTP_PORT**
```text
Nombre: SMTP_PORT
Valor: 587
```text

### **SMTP_USER**
```text
Nombre: SMTP_USER
Valor: tu-email@gmail.com
```text

### **SMTP_PASS**
```text
Nombre: SMTP_PASS
Valor: tu-app-password
```text

---

## 🎯 **Secrets Mínimos Requeridos**

Para que el CI/CD funcione básicamente, solo necesitas:

1. ✅ **FLY_API_TOKEN** (OBLIGATORIO)
2. ✅ **NEXT_PUBLIC_SUPABASE_URL** (Ya configurado)
3. ✅ **NEXT_PUBLIC_SUPABASE_ANON_KEY** (Ya configurado)
4. ✅ **SUPABASE_SERVICE_ROLE_KEY** (Ya configurado)

---

## 🔄 **Actualizar Workflows**

Una vez configurados los secrets, los workflows se ejecutarán automáticamente en:

- **Staging:** Push a la rama `dev`
- **Producción:** Push a la rama `main`

---

## ✅ **Verificación**

Para verificar que los secrets están configurados:

1. Ve a tu repositorio → Settings → Secrets and variables → Actions
2. Deberías ver todos los secrets listados
3. Haz un push a la rama `dev` o `main` para probar el deploy automático

---

## 🚨 **Importante**

- **Nunca** compartas tus secrets públicamente
- **Nunca** los incluyas en el código
- **Siempre** usa variables de entorno para secrets
- **Rota** los tokens periódicamente por seguridad

---

*Guía creada para ContenidosX - 10 de septiembre de 2025*
