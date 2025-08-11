-- RLS bootstrap using application_name tags:
--   SET application_name = 'gymapp tenant=<uuid> user=<uuid>'
-- The functions below extract those IDs for policies.

create schema if not exists app;

create or replace function app.tenant_id() returns text
language sql stable as $$
  select nullif(
    regexp_replace(current_setting('application_name', true), '.*tenant=([0-9a-fA-F-]{36}).*', '\1'),
    ''
  );
$$;

create or replace function app.user_id() returns text
language sql stable as $$
  select nullif(
    regexp_replace(current_setting('application_name', true), '.*user=([0-9a-fA-F-]{36}).*', '\1'),
    ''
  );
$$;

-- PROGRAM
alter table "Program" enable row level security;
alter table "Program" force row level security;
drop policy if exists "program_tenant_or_owner" on "Program";
create policy "program_tenant_or_owner" on "Program"
using (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
)
with check (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
);

-- PROGRAM DAY
alter table "ProgramDay" enable row level security;
alter table "ProgramDay" force row level security;
drop policy if exists "programday_tenant_or_owner" on "ProgramDay";
create policy "programday_tenant_or_owner" on "ProgramDay"
using (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
)
with check (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
);

-- PROGRAM EXERCISE
alter table "ProgramExercise" enable row level security;
alter table "ProgramExercise" force row level security;
drop policy if exists "programexercise_tenant_or_owner" on "ProgramExercise";
create policy "programexercise_tenant_or_owner" on "ProgramExercise"
using (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
)
with check (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
);

-- SESSION
alter table "Session" enable row level security;
alter table "Session" force row level security;
drop policy if exists "session_tenant_or_owner" on "Session";
create policy "session_tenant_or_owner" on "Session"
using (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
)
with check (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
);

-- SET
alter table "Set" enable row level security;
alter table "Set" force row level security;
drop policy if exists "set_tenant_or_owner" on "Set";
create policy "set_tenant_or_owner" on "Set"
using (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
)
with check (
  ("tenantId" is not null and "tenantId" = app.tenant_id())
  or
  ("userId"   is not null and "userId"   = app.user_id())
);

-- EXERCISE (tenant-scoped only)
alter table "Exercise" enable row level security;
alter table "Exercise" force row level security;
drop policy if exists "exercise_by_tenant" on "Exercise";
create policy "exercise_by_tenant" on "Exercise"
using ("tenantId" = app.tenant_id())
with check ("tenantId" = app.tenant_id());

-- EVENT ANALYTICS (tenant scope; allow user-owned rows too)
alter table "EventAnalytics" enable row level security;
alter table "EventAnalytics" force row level security;
drop policy if exists "eventanalytics_by_tenant_or_user" on "EventAnalytics";
create policy "eventanalytics_by_tenant_or_user" on "EventAnalytics"
using (
  ("tenantId" = app.tenant_id())
  or ("userId" is not null and "userId" = app.user_id())
)
with check (
  ("tenantId" = app.tenant_id())
  or ("userId" is not null and "userId" = app.user_id())
);
