-- Run this in Supabase SQL Editor.
create table if not exists public.contributors (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  photo text,
  amount numeric not null default 0,
  category text,
  contribution text,
  icon text default '🙏',
  position integer not null default 9999,
  created_at timestamptz not null default now()
);

alter table public.contributors enable row level security;

drop policy if exists "Public can view contributors" on public.contributors;
create policy "Public can view contributors"
on public.contributors for select
using (true);

drop policy if exists "Authenticated users can insert contributors" on public.contributors;
create policy "Authenticated users can insert contributors"
on public.contributors for insert to authenticated
with check (true);

drop policy if exists "Authenticated users can update contributors" on public.contributors;
create policy "Authenticated users can update contributors"
on public.contributors for update to authenticated
using (true) with check (true);

drop policy if exists "Authenticated users can delete contributors" on public.contributors;
create policy "Authenticated users can delete contributors"
on public.contributors for delete to authenticated
using (true);

insert into storage.buckets (id, name, public)
values ('contributor-photos', 'contributor-photos', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view contributor photos" on storage.objects;
create policy "Public can view contributor photos"
on storage.objects for select
using (bucket_id = 'contributor-photos');

drop policy if exists "Authenticated users can upload contributor photos" on storage.objects;
create policy "Authenticated users can upload contributor photos"
on storage.objects for insert to authenticated
with check (bucket_id = 'contributor-photos');

drop policy if exists "Authenticated users can update contributor photos" on storage.objects;
create policy "Authenticated users can update contributor photos"
on storage.objects for update to authenticated
using (bucket_id = 'contributor-photos') with check (bucket_id = 'contributor-photos');

drop policy if exists "Authenticated users can delete contributor photos" on storage.objects;
create policy "Authenticated users can delete contributor photos"
on storage.objects for delete to authenticated
using (bucket_id = 'contributor-photos');
