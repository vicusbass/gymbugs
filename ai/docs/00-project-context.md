# Project Context — Gym App

**Goal:** Multi-tenant gym programming + tracking + analytics. Web first (mobile responsive), future mobile app using the same REST API.

## Users & Roles

- Owner/Coach: creates programs, manages library, views analytics.
- Member: creates program, follows program, logs sessions/sets.
- Admin (internal): debugging/ops.

## Tenancy

- Pooled Postgres; every record has `tenant_id`. RLS in Postgres enforces isolation. App always sets `app.tenant_id` on DB session per request.

## Core Concepts

- Exercise Library → Programs → Program Days → Program Exercises → Sessions → Sets.
- Analytics via `events_analytics` and aggregate queries/materialized views.

## Non-Goals (for now)

- Payment/billing, social features, native video hosting, offline-first mobile.
