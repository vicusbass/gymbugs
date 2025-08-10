# Test Strategy

- Use Vitest for unit tests
- Use React Testing Library
- Unit: pure helpers (volume calc, PR detection, adherence calc).
- Integration: API route handlers with an in-memory or isolated schema (use a test schema/DB branch).
- Fixtures: factories for tenant/user/membership.
- Happy-path + key edge cases (empty library, negative reps rejected, cross-tenant access denied).
