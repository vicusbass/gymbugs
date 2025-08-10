# Domain Model Glossary

- **Tenant**: Logical organization/gym. Key for isolation.
- **Membership**: (tenant, user, role).
- **Exercise**: Canonical movement with metadata (name, muscle_group, yt_url).
- **Program**: Plan over time; cadence weekly/monthly/multi-month.
- **Program Day**: Day within a program (by index or date).
- **Program Exercise**: An exercise placed on a day, with targets (sets, reps).
- **Session**: A realized workout for a user on a date, derived from a program day.
- **Set**: A single attempt with weight, reps, rpe.
- **EventAnalytics**: Flexible telemetry for charts (adherence, PRs, volume).
