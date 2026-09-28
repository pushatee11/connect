create table if not exists public.waitlist_submissions (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  full_name text not null,
  phone text not null,
  email text not null,
  area text not null,
  customer_type text not null,
  preferred_plan text not null,
  priority text not null,
  landmark text,
  consent boolean not null,
  consented_at timestamptz not null default now(),
  constraint waitlist_full_name_length
    check (char_length(btrim(full_name)) between 2 and 120),
  constraint waitlist_phone_length
    check (char_length(btrim(phone)) between 5 and 40),
  constraint waitlist_email_length
    check (char_length(btrim(email)) between 3 and 254),
  constraint waitlist_area_length
    check (char_length(btrim(area)) between 2 and 120),
  constraint waitlist_customer_type_valid
    check (customer_type in ('Individual / Home', 'Business')),
  constraint waitlist_plan_valid
    check (preferred_plan in ('Not sure yet', 'Home plan', 'Business plan')),
  constraint waitlist_priority_valid
    check (priority in (
      'Fast internet',
      'Affordable pricing',
      'Reliable connection',
      'Unlimited data',
      'Business internet',
      'Good customer service',
      'Wide coverage',
      'Flexible plans',
      'Easy installation'
    )),
  constraint waitlist_landmark_length
    check (landmark is null or char_length(landmark) <= 200),
  constraint waitlist_consent_required
    check (consent is true)
);

alter table public.waitlist_submissions enable row level security;

revoke all on table public.waitlist_submissions from anon, authenticated;
grant insert on table public.waitlist_submissions to anon, authenticated;

drop policy if exists "Visitors can submit waitlist signups"
  on public.waitlist_submissions;

create policy "Visitors can submit waitlist signups"
  on public.waitlist_submissions
  for insert
  to anon, authenticated
  with check (consent is true);
