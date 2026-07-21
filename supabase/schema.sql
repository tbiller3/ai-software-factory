create extension if not exists "pgcrypto";

create table if not exists workflow_runs (
  id uuid primary key default gen_random_uuid(),
  run_name text not null,
  status text not null default 'started',
  initiated_by text,
  idea_input text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists agent_outputs (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null references workflow_runs(id) on delete cascade,
  layer text not null,
  agent_name text not null,
  output_json jsonb not null,
  created_at timestamptz not null default now()
);

create table if not exists agent_audit_log (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null references workflow_runs(id) on delete cascade,
  event_type text not null,
  actor text not null,
  event_payload jsonb,
  created_at timestamptz not null default now()
);

create table if not exists approval_events (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null references workflow_runs(id) on delete cascade,
  gate_name text not null,
  decision text not null,
  decided_by text,
  notes text,
  created_at timestamptz not null default now()
);

create index if not exists idx_agent_outputs_run_id on agent_outputs(run_id);
create index if not exists idx_audit_run_id on agent_audit_log(run_id);
create index if not exists idx_approval_run_id on approval_events(run_id);
