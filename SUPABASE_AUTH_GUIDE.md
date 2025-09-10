# 🔐 Guía de Configuración de Autenticación Supabase

## 🎯 **Configuración de Autenticación para ContenidosX**

Esta guía te ayudará a configurar la autenticación completa en Supabase para ContenidosX.

---

## 📋 **Paso 1: Acceder a Supabase Dashboard**

1. Ve a <0>
2. Inicia sesión con tu cuenta
3. Selecciona tu proyecto: `hojusdfclfrovxroumff`

---

## 🔧 **Paso 2: Configurar Autenticación**

### **2.1 Habilitar Proveedores de Autenticación:**

1. Ve a **Authentication** → **Providers**
2. **Email:** ✅ Ya habilitado
3. **Google:** Configurar si deseas
4. **GitHub:** Configurar si deseas
5. **Discord:** Configurar si deseas

### **2.2 Configurar Email:**

1. Ve a **Authentication** → **Settings**
2. **Site URL:** `<0>
3. **Redirect URLs:**
   - `<0>
   - `<0>
4. **Enable email confirmations:** ✅ (recomendado)

---

## 🗄️ **Paso 3: Configurar Base de Datos**

### **3.1 Crear Tablas Necesarias:**

Ejecuta este SQL en el **SQL Editor** de Supabase:

```sql
-- Tabla de perfiles de usuario
CREATE TABLE IF NOT EXISTS public.users_profile (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email TEXT,
    full_name TEXT,
    avatar_url TEXT,
    stripe_customer_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de creadores
CREATE TABLE IF NOT EXISTS public.creators (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users_profile(id) ON DELETE CASCADE,
    display_name TEXT NOT NULL,
    bio TEXT,
    avatar_url TEXT,
    cover_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de suscripciones de fans
CREATE TABLE IF NOT EXISTS public.fan_subscriptions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users_profile(id) ON DELETE CASCADE,
    creator_id UUID REFERENCES public.creators(id) ON DELETE CASCADE,
    stripe_subscription_id TEXT UNIQUE,
    stripe_customer_id TEXT,
    status TEXT DEFAULT 'active',
    current_period_start TIMESTAMP WITH TIME ZONE,
    current_period_end TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, creator_id)
);

-- Tabla de contenido
CREATE TABLE IF NOT EXISTS public.content (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    creator_id UUID REFERENCES public.creators(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    content_type TEXT DEFAULT 'post', -- 'post', 'image', 'video'
    content_url TEXT,
    is_premium BOOLEAN DEFAULT FALSE,
    price_cents INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de bookmarks
CREATE TABLE IF NOT EXISTS public.bookmarks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.users_profile(id) ON DELETE CASCADE,
    content_id UUID REFERENCES public.content(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, content_id)
);
```text

### **3.2 Configurar Row Level Security (RLS):**

```sql
-- Habilitar RLS en todas las tablas
ALTER TABLE public.users_profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.creators ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fan_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

-- Políticas para users_profile
CREATE POLICY "Users can view own profile" ON public.users_profile
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users_profile
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.users_profile
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Políticas para creators
CREATE POLICY "Anyone can view creators" ON public.creators
    FOR SELECT USING (true);

CREATE POLICY "Users can create creator profile" ON public.creators
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own creator profile" ON public.creators
    FOR UPDATE USING (auth.uid() = user_id);

-- Políticas para content
CREATE POLICY "Anyone can view public content" ON public.content
    FOR SELECT USING (is_premium = false);

CREATE POLICY "Subscribers can view premium content" ON public.content
    FOR SELECT USING (
        is_premium = true AND EXISTS (
            SELECT 1 FROM public.fan_subscriptions
            WHERE user_id = auth.uid()
            AND creator_id = content.creator_id
            AND status = 'active'
            AND current_period_end > NOW()
        )
    );

CREATE POLICY "Creators can manage own content" ON public.content
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.creators
            WHERE id = content.creator_id
            AND user_id = auth.uid()
        )
    );

-- Políticas para fan_subscriptions
CREATE POLICY "Users can view own subscriptions" ON public.fan_subscriptions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Creators can view their subscribers" ON public.fan_subscriptions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.creators
            WHERE id = fan_subscriptions.creator_id
            AND user_id = auth.uid()
        )
    );

-- Políticas para bookmarks
CREATE POLICY "Users can manage own bookmarks" ON public.bookmarks
    FOR ALL USING (auth.uid() = user_id);
```text

---

## 🔄 **Paso 4: Configurar Triggers**

### **4.1 Trigger para crear perfil automáticamente:**

```sql
-- Función para crear perfil automáticamente
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users_profile (id, email, full_name, avatar_url)
    VALUES (
        NEW.id,
        NEW.email,
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'avatar_url'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para ejecutar la función
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```text

### **4.2 Trigger para actualizar timestamps:**

```sql
-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para todas las tablas
CREATE TRIGGER update_users_profile_updated_at
    BEFORE UPDATE ON public.users_profile
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_creators_updated_at
    BEFORE UPDATE ON public.creators
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_fan_subscriptions_updated_at
    BEFORE UPDATE ON public.fan_subscriptions
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_content_updated_at
    BEFORE UPDATE ON public.content
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
```text

---

## 🧪 **Paso 5: Testing de Autenticación**

### **5.1 Probar Registro:**
1. Ve a <0>
2. Haz clic en "Registrarse"
3. Completa el formulario
4. Verifica el email (si está habilitado)

### **5.2 Probar Login:**
1. Ve a <0>
2. Haz clic en "Iniciar sesión"
3. Ingresa tus credenciales
4. Verifica que se redirige correctamente

---

## 🔧 **Paso 6: Configurar Cliente de Autenticación**

### **6.1 Actualizar AuthStatus.tsx:**

```typescript
import { useState, useEffect } from 'react';
import { supabaseAnon } from '@/lib/supabaseClient';
import Link from 'next/link';

export default function AuthStatus() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Obtener sesión actual
    const getSession = async () => {
      const { data: { session } } = await supabaseAnon.auth.getSession();
      setUser(session?.user ?? null);
      setLoading(false);
    };

    getSession();

    // Escuchar cambios de autenticación
    const { data: { subscription } } = supabaseAnon.auth.onAuthStateChange(
      (event, session) => {
        setUser(session?.user ?? null);
        setLoading(false);
      }
    );

    return () => subscription.unsubscribe();
  }, []);

  const handleSignOut = async () => {
    await supabaseAnon.auth.signOut();
  };

  if (loading) {
    return <div className="text-sm text-gray-400">Cargando...</div>;
  }

  if (user) {
    return (
      <div className="flex items-center gap-2">
        <span className="text-sm">Hola, {user.email}</span>
        <Link href="/fan/dashboard" className="text-sm hover:underline">
          Dashboard
        </Link>
        <button
          onClick={handleSignOut}
          className="text-sm text-red-400 hover:underline"
        >
          Cerrar sesión
        </button>
      </div>
    );
  }

  return (
    <div className="flex items-center gap-2">
      <Link href="/auth" className="text-sm hover:underline">
        Iniciar sesión
      </Link>
    </div>
  );
}
```text

---

## ✅ **Checklist de Configuración**

- [ ] Proveedores de autenticación configurados
- [ ] URLs de redirección configuradas
- [ ] Tablas de base de datos creadas
- [ ] Políticas RLS configuradas
- [ ] Triggers configurados
- [ ] Testing de registro/login
- [ ] Cliente de autenticación actualizado

---

## 🚨 **Consideraciones de Seguridad**

- **Habilita RLS** en todas las tablas
- **Valida** los datos del usuario
- **Maneja** errores de autenticación
- **Configura** timeouts apropiados
- **Monitorea** intentos de login fallidos

---

*Guía creada para ContenidosX - 10 de septiembre de 2025*
