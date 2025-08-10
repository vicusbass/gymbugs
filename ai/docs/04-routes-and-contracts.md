# REST Contracts (v0)

## POST /api/sessions/generate

Create a session for the current user from a program day.
Req: { programDayId: string, sessionDate?: ISO }
Res: { id: string, sessionDate: ISO, status: "planned" }

## PATCH /api/sets/:id

Req: { weight?: number, reps?: number, rpe?: number }
Res: { id, weight, reps, rpe }

## GET /api/analytics/overview?range=last_30d

Res: {
  totalSessions: number,
  completedSessions: number,
  volumeKg: number,
  prCount: number,
  adherencePct: number
}
