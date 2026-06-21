-- =====================================================================
-- Online Notepad — Supabase database schema
-- Run this entire file once inside Supabase → SQL Editor → New query
-- =====================================================================

-- 1) USERS table -------------------------------------------------------
-- Stores sign-up requests. New rows default to approved = false.
-- You (the admin) flip approved to true in the Table Editor to let
-- a user log in.
create table if not exists public.users (
    id            uuid primary key default gen_random_uuid(),
    user_id       text unique not null,           -- the login name chosen by the user
    password_hash text not null,                  -- SHA-256 hex of the password
    approved      boolean not null default false, -- you set this to true manually
    created_at    timestamptz not null default now()
);

-- 2) NOTES table -------------------------------------------------------
create table if not exists public.notes (
    id         uuid primary key default gen_random_uuid(),
    user_id    text not null references public.users(user_id) on delete cascade,
    title      text not null default 'Untitled',
    content    text not null default '',
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create index if not exists notes_user_id_idx on public.notes(user_id);

-- 3) Row Level Security -----------------------------------------------
-- This beginner project uses the public "anon" API key from the
-- browser and a custom (non-Supabase-Auth) login flow. To keep things
-- simple we DISABLE row level security on these two tables.
--
-- WARNING: with RLS off, anyone who knows your Supabase URL + anon
-- key can read/modify these tables. That is OK for learning, but do
-- NOT store anything sensitive here, and tighten this up before
-- going to real production.
alter table public.users disable row level security;
alter table public.notes disable row level security;
