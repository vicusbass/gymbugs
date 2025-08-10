# Code Style & Conventions

- TypeScript strict on. No implicit `any`.
- Use Biome for format and linting
- Server-first: prefer server components; client components only for interactivity.
- **Validation:** Zod at API boundaries; never trust client input.
- **Tenancy:** Never accept `tenant_id` from request body; derive from session.
- **Errors:** Throw typed errors; map to proper HTTP codes.
- **Naming:** snake_case in DB, camelCase in TS. Ids are UUID v4.
- **Tests:** Unit (domain utils), integration (API routes), e2e later.
- **Commits:** Conventional Commits (`feat:`, `fix:`, etc.).
