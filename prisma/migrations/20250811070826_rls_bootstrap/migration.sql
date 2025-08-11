-- CreateTable
CREATE TABLE "public"."Tenant" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "plan" TEXT NOT NULL DEFAULT 'free',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Tenant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Membership" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" TEXT NOT NULL,

    CONSTRAINT "Membership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Exercise" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "muscle" TEXT,
    "ytUrl" TEXT,
    "notes" TEXT,

    CONSTRAINT "Exercise_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Program" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT,
    "userId" TEXT,
    "name" TEXT NOT NULL,
    "cadence" TEXT NOT NULL,
    "startDate" TIMESTAMP(3),
    "endDate" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Program_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ProgramDay" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT,
    "userId" TEXT,
    "programId" TEXT NOT NULL,
    "dayIndex" INTEGER,
    "date" TIMESTAMP(3),

    CONSTRAINT "ProgramDay_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ProgramExercise" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT,
    "userId" TEXT,
    "programDayId" TEXT NOT NULL,
    "exerciseId" TEXT NOT NULL,
    "order" INTEGER NOT NULL,
    "targetSets" INTEGER NOT NULL,
    "targetReps" INTEGER NOT NULL,
    "tempo" TEXT,
    "restSeconds" INTEGER,
    "notes" TEXT,

    CONSTRAINT "ProgramExercise_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Session" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT,
    "userId" TEXT NOT NULL,
    "programDayId" TEXT,
    "sessionDate" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'planned',

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Set" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT,
    "userId" TEXT,
    "sessionId" TEXT NOT NULL,
    "programExerciseId" TEXT,
    "setIndex" INTEGER NOT NULL,
    "weight" DECIMAL(65,30),
    "reps" INTEGER,
    "rpe" DECIMAL(65,30),

    CONSTRAINT "Set_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."EventAnalytics" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "userId" TEXT,
    "ts" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT NOT NULL,
    "props" JSONB NOT NULL,

    CONSTRAINT "EventAnalytics_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Tenant_slug_key" ON "public"."Tenant"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Membership_tenantId_userId_key" ON "public"."Membership"("tenantId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "Exercise_tenantId_name_key" ON "public"."Exercise"("tenantId", "name");

-- CreateIndex
CREATE INDEX "Program_tenantId_name_idx" ON "public"."Program"("tenantId", "name");

-- CreateIndex
CREATE INDEX "Program_userId_name_idx" ON "public"."Program"("userId", "name");

-- CreateIndex
CREATE INDEX "ProgramDay_tenantId_programId_idx" ON "public"."ProgramDay"("tenantId", "programId");

-- CreateIndex
CREATE INDEX "ProgramDay_userId_programId_idx" ON "public"."ProgramDay"("userId", "programId");

-- CreateIndex
CREATE INDEX "ProgramExercise_tenantId_programDayId_idx" ON "public"."ProgramExercise"("tenantId", "programDayId");

-- CreateIndex
CREATE INDEX "ProgramExercise_userId_programDayId_idx" ON "public"."ProgramExercise"("userId", "programDayId");

-- CreateIndex
CREATE INDEX "Session_tenantId_userId_sessionDate_idx" ON "public"."Session"("tenantId", "userId", "sessionDate");

-- CreateIndex
CREATE INDEX "Session_userId_sessionDate_idx" ON "public"."Session"("userId", "sessionDate");

-- CreateIndex
CREATE INDEX "Set_tenantId_sessionId_idx" ON "public"."Set"("tenantId", "sessionId");

-- CreateIndex
CREATE INDEX "Set_userId_sessionId_idx" ON "public"."Set"("userId", "sessionId");

-- CreateIndex
CREATE INDEX "EventAnalytics_tenantId_type_ts_idx" ON "public"."EventAnalytics"("tenantId", "type", "ts");

-- AddForeignKey
ALTER TABLE "public"."Membership" ADD CONSTRAINT "Membership_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Membership" ADD CONSTRAINT "Membership_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Exercise" ADD CONSTRAINT "Exercise_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Program" ADD CONSTRAINT "Program_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Program" ADD CONSTRAINT "Program_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProgramDay" ADD CONSTRAINT "ProgramDay_programId_fkey" FOREIGN KEY ("programId") REFERENCES "public"."Program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProgramDay" ADD CONSTRAINT "ProgramDay_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProgramDay" ADD CONSTRAINT "ProgramDay_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProgramExercise" ADD CONSTRAINT "ProgramExercise_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProgramExercise" ADD CONSTRAINT "ProgramExercise_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProgramExercise" ADD CONSTRAINT "ProgramExercise_programDayId_fkey" FOREIGN KEY ("programDayId") REFERENCES "public"."ProgramDay"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ProgramExercise" ADD CONSTRAINT "ProgramExercise_exerciseId_fkey" FOREIGN KEY ("exerciseId") REFERENCES "public"."Exercise"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Session" ADD CONSTRAINT "Session_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Session" ADD CONSTRAINT "Session_programDayId_fkey" FOREIGN KEY ("programDayId") REFERENCES "public"."ProgramDay"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Set" ADD CONSTRAINT "Set_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Set" ADD CONSTRAINT "Set_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Set" ADD CONSTRAINT "Set_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "public"."Session"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Set" ADD CONSTRAINT "Set_programExerciseId_fkey" FOREIGN KEY ("programExerciseId") REFERENCES "public"."ProgramExercise"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."EventAnalytics" ADD CONSTRAINT "EventAnalytics_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
