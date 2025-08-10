# Reusable Agent Tasks

## Implement API route

Inputs: route path, method, zod schema, prisma ops, auth role
Steps:

1) Parse & validate input (Zod).
2) Read tenant and user from session.
3) `SET app.tenant_id` for DB session (or Prisma middleware).
4) Prisma query/mutation with `(tenant_id: ctx.tenantId)`.
5) Return typed JSON; map known errors to HTTP codes.
6) Add a minimal integration test.

## Add analytics event

Inputs: type, props
Steps:

1) Create `events_analytics` row with tenant_id, user_id, ts, type, props.
2) If event changes aggregates (e.g., PR), write a follow-up job/event.

## Create mobile-friendly form

- Use shadcn/ui inputs; label + helper text; `inputMode="numeric"` for weights/reps.
- Client-safe only; server validates again.
