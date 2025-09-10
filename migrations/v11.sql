-- v11: Lives + Reminders
create table if not exists live_events (
  id uuid primary key default gen_random_uuid(),
  creator_id uuid not null references creators(id) on delete cascade,
  title text not null,
  start_at timestamptz not null,
  duration_min int not null default 60,
  visibility text not null default 'public',
  created_at timestamptz default now()
);

create table if not exists live_reminders_sent (
  event_id uuid not null references live_events(id) on delete cascade,
  user_id uuid not null,
  sent_at timestamptz default now(),
  primary key (event_id, user_id)
);

alter table live_events enable row level security;
create policy if not exists live_events_select_all on live_events for select using (true);

alter table live_reminders_sent enable row level security;
create policy if not exists reminders_select_service on live_reminders_sent for select using (auth.role() = 'service_role');
create policy if not exists reminders_insert_service on live_reminders_sent for insert with check (auth.role() = 'service_role');
