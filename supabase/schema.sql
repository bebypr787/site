-- Creators (simplificado)
create table if not exists creators (
  id uuid primary key default gen_random_uuid(),
  username text unique,
  name text,
  avatar_url text,
  cover_url text,
  country text,
  age int
);

-- Promos del banner
create table if not exists banner_promos (
  id uuid primary key default gen_random_uuid(),
  creator_id uuid references creators(id) on delete cascade,
  name text,
  username text,
  avatar_url text,
  cover_url text,
  tier text default 'Premium',
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  created_at timestamptz default now()
);

-- Promos del sidebar
create table if not exists sidebar_promos (
  id uuid primary key default gen_random_uuid(),
  creator_id uuid references creators(id) on delete cascade,
  name text,
  avatar_url text,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  created_at timestamptz default now()
);

-- RLS básico (lectura pública de promos activas)
alter table banner_promos enable row level security;
alter table sidebar_promos enable row level security;

create policy if not exists banner_select_active on banner_promos
for select using (now() < ends_at);

create policy if not exists sidebar_select_active on sidebar_promos
for select using (now() < ends_at);

-- Inserciones solo por servicio
create policy if not exists banner_insert_service on banner_promos
for insert with check (auth.role() = 'service_role');

create policy if not exists sidebar_insert_service on sidebar_promos
for insert with check (auth.role() = 'service_role');


-- FANS (opcional: puedes usar auth.users) 
create table if not exists fans (
  id uuid primary key default gen_random_uuid(),
  username text unique,
  created_at timestamptz default now()
);

-- Bookmarks del fan
create table if not exists fan_bookmarks (
  user_id uuid not null,
  creator_id uuid not null references creators(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, creator_id)
);

-- Subscriptions del fan
create table if not exists fan_subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  creator_id uuid not null references creators(id) on delete cascade,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  created_at timestamptz default now()
);

-- RLS
alter table fan_bookmarks enable row level security;
alter table fan_subscriptions enable row level security;

-- user solo ve/gestiona lo suyo (asumiendo JWT de Supabase Auth, auth.uid())
create policy if not exists fb_select_self on fan_bookmarks for select using (user_id = auth.uid());
create policy if not exists fb_insert_self on fan_bookmarks for insert with check (user_id = auth.uid());
create policy if not exists fb_delete_self on fan_bookmarks for delete using (user_id = auth.uid());

create policy if not exists fs_select_self on fan_subscriptions for select using (user_id = auth.uid());
create policy if not exists fs_insert_self on fan_subscriptions for insert with check (user_id = auth.uid());
create policy if not exists fs_delete_self on fan_subscriptions for delete using (user_id = auth.uid());


-- Catálogo simple de precios de suscripción por creador (opcional)
create table if not exists creator_prices (
  id uuid primary key default gen_random_uuid(),
  creator_id uuid references creators(id) on delete cascade,
  usd_cents int not null default 999, -- 9.99 USD
  currency text not null default 'usd',
  stripe_price_id text, -- si ya existe en Stripe
  created_at timestamptz default now()
);

-- Campos Stripe en suscripciones de fans
alter table fan_subscriptions
  add column if not exists stripe_customer_id text,
  add column if not exists stripe_subscription_id text,
  add column if not exists currency text default 'usd',
  add column if not exists amount_cents int default 999;


-- Mapea usuario (Supabase) a Stripe Customer
create table if not exists users_profile (
  user_id uuid primary key,
  email text,
  stripe_customer_id text unique,
  created_at timestamptz default now()
);

-- Extiende catálogo de precios con product_id
alter table creator_prices
  add column if not exists stripe_product_id text;


-- Lives programados por creadores
create table if not exists live_events (
  id uuid primary key default gen_random_uuid(),
  creator_id uuid not null references creators(id) on delete cascade,
  title text not null,
  start_at timestamptz not null,
  duration_min int not null default 60,
  visibility text not null default 'public', -- 'public' | 'subscribers'
  created_at timestamptz default now()
);

-- Control para evitar enviar emails duplicados por evento
create table if not exists live_reminders_sent (
  event_id uuid not null references live_events(id) on delete cascade,
  user_id uuid not null,
  sent_at timestamptz default now(),
  primary key (event_id, user_id)
);

alter table live_events enable row level security;
create policy if not exists live_events_select_all on live_events for select using (true);
-- Inserción restringida (en producción: auth.uid() == creador dueño); aquí demo permitimos service_role
create policy if not exists live_events_insert_service on live_events for insert with check (auth.role() = 'service_role');

alter table live_reminders_sent enable row level security;
create policy if not exists reminders_select_service on live_reminders_sent for select using (auth.role() = 'service_role');
create policy if not exists reminders_insert_service on live_reminders_sent for insert with check (auth.role() = 'service_role');
