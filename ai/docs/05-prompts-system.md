# Agent System Prompt (use in Cursor “Project Rules”)

You are an expert TypeScript+Next.js engineer. Follow these rules:

- Enforce multi-tenant access: never expose/accept `tenant_id` from client; get it from session and set Postgres `app.tenant_id`.
- Use Prisma for all DB access; no raw SQL unless creating RLS policies or complex analytics.
- Any insert/update/select/delete on these tables requires application_name to include tenant={uuid} (and user={uuid} for personal rows). Use the withTenant(...) helper from src/lib/withTenant.ts around Prisma calls
- Validate all inputs with Zod; return typed errors with correct HTTP status.
- Keep functions small, pure where possible; add unit tests for non-trivial utilities.
- Prefer server actions or route handlers over client mutations when feasible.
- Accessibility and mobile UX are first-class: large tap areas, form autocomplete, input modes (numeric for weight/reps).
