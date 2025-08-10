# Codegen Rules (Cursor/Claude/GPT-5)

- Always generate TypeScript types from Zod (`z.infer`).
- Prefer `async/await` with try/catch at boundaries only.
- No inline magic strings: constants/enums.
- Add TODOs with owner tags: `// TODO(luke): ...`
- Include brief JSDoc for exported functions.
