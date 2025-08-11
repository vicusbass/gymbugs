import { Prisma, PrismaClient } from '@prisma/client';

const db = new PrismaClient();

async function main() {
  // Base records
  const tenant = await db.tenant.upsert({
    where: { slug: 'demo-gym' },
    update: {},
    create: { name: 'Demo Gym', slug: 'demo-gym' },
  });

  const user = await db.user.upsert({
    where: { email: 'demo@gym.app' },
    update: {},
    create: { email: 'demo@gym.app', name: 'Demo User' },
  });

  await db.membership.upsert({
    where: { tenantId_userId: { tenantId: tenant.id, userId: user.id } },
    update: {},
    create: { tenantId: tenant.id, userId: user.id, role: 'owner' },
  });

  // Exercises (tenant-scoped)
  const squat = await db.exercise.upsert({
    where: { tenantId_name: { tenantId: tenant.id, name: 'Back Squat' } },
    update: {},
    create: {
      tenantId: tenant.id,
      name: 'Back Squat',
      muscle: 'legs',
      ytUrl: 'https://youtu.be/ultWZbUMPL8',
    },
  });

  const bench = await db.exercise.upsert({
    where: { tenantId_name: { tenantId: tenant.id, name: 'Bench Press' } },
    update: {},
    create: {
      tenantId: tenant.id,
      name: 'Bench Press',
      muscle: 'chest',
      ytUrl: 'https://youtu.be/gRVjAtPip0Y',
    },
  });

  // Shared (tenant) program
  const shared = await db.program.create({
    data: {
      tenantId: tenant.id,
      name: 'Full Body Beginner',
      cadence: 'weekly',
      days: {
        create: [
          {
            tenantId: tenant.id,
            dayIndex: 0,
            exercises: {
              create: [
                {
                  tenantId: tenant.id,
                  order: 1,
                  targetSets: 3,
                  targetReps: 5,
                  exerciseId: squat.id,
                },
                {
                  tenantId: tenant.id,
                  order: 2,
                  targetSets: 3,
                  targetReps: 5,
                  exerciseId: bench.id,
                },
              ],
            },
          },
          { tenantId: tenant.id, dayIndex: 2 },
        ],
      },
    },
    include: { days: { include: { exercises: true } } },
  });

  // Personal program (user-only)
  const personal = await db.program.create({
    data: {
      userId: user.id,
      name: 'Personal Cut',
      cadence: 'weekly',
      days: {
        create: [
          {
            userId: user.id,
            dayIndex: 1,
            exercises: {
              create: [
                {
                  userId: user.id,
                  order: 1,
                  targetSets: 4,
                  targetReps: 8,
                  exerciseId: bench.id,
                },
              ],
            },
          },
        ],
      },
    },
  });

  // Example session + sets for analytics demos
  const session = await db.session.create({
    data: {
      tenantId: tenant.id,
      userId: user.id,
      programDayId: shared.days[0].id,
      sessionDate: new Date(),
      status: 'done',
      sets: {
        create: [
          {
            tenantId: tenant.id,
            userId: user.id,
            setIndex: 1,
            weight: new Prisma.Decimal('80'),
            reps: 5,
            rpe: new Prisma.Decimal('8'),
          },
          {
            tenantId: tenant.id,
            userId: user.id,
            setIndex: 2,
            weight: new Prisma.Decimal('80'),
            reps: 5,
            rpe: new Prisma.Decimal('8.5'),
          },
        ],
      },
    },
  });

  console.log('Seeded:', {
    tenant: tenant.slug,
    user: user.email,
    shared: shared.name,
    personal: personal.name,
    session: session.id,
  });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await db.$disconnect();
  });
