# Architecture Decisions (ADRs)

- **DB:** Postgres (Neon/Supabase) for RLS + strong SQL. Prisma for ORM.
- **API:** REST via Next.js route handlers (`app/api/*`). Stable, mobile-ready.
- **Auth:** Auth.js (NextAuth) with Email/OAuth; membership table ties user→tenant.
- **UI:** Next.js App Router + Tailwind + shadcn/ui. Mobile-first layouts.
- **Validation:** Zod schemas shared client/server.
- **Analytics:** Append-only `events_analytics` + SQL rollups; later materialized views.
- **Jobs:** Vercel Cron or Inngest for rollups/summaries.
- **Error handling:** Typed error shapes, HTTP status discipline, no `any`.
