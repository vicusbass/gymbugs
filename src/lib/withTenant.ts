import type { PrismaClient } from '@prisma/client';
import { prisma } from './prisma';

/**
 * Runs all DB work inside a single transaction while tagging the connection's
 * application_name with "tenant=<uuid> user=<uuid>". Safe on Neon/Supabase/vanilla PG.
 */
export async function withTenant<T>(
  tenantId: string,
  userId: string,
  fn: (tx: PrismaClient) => Promise<T>,
) {
  // biome-ignore lint/suspicious/noExplicitAny: <To be fixed>
  return prisma.$transaction(async (tx: { $executeRaw: any }) => {
    const tag = `gymapp tenant=${tenantId} user=${userId}`;
    // Parameterized to avoid SQL injection; set for *this* transaction only.
    await tx.$executeRaw`SELECT set_config('application_name', ${tag}, true)`;
    return fn(tx);
  });
}
