-- CreateEnum
CREATE TYPE "QrCodeErrorCorrectionLevel" AS ENUM ('L', 'M', 'Q', 'H');

-- CreateEnum
CREATE TYPE "QrDataStyle" AS ENUM ('SQUARES', 'DOTS');

-- CreateEnum
CREATE TYPE "ProjectApiKeyScope" AS ENUM ('ALL');

-- CreateEnum
CREATE TYPE "IdentifierStoreMethod" AS ENUM ('LOCAL_STORAGE', 'SESSION_STORAGE', 'COOKIE', 'IP_ADDRESS', 'USER_AGENT', 'IMEI', 'ICCID', 'MULTIPLE');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "lastLoggedInAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastRequestedApiAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedDashboardAt" TIMESTAMP(3),
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "company" TEXT NOT NULL,
    "profilePicture" TEXT,
    "timeZone" TEXT,
    "locale" TEXT,
    "passwordHash" TEXT NOT NULL,
    "accessToken" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProjectApiKey" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "lastGeneratedTokenAt" TIMESTAMP(3),
    "lastQueriedProjectAt" TIMESTAMP(3),
    "apiKey" TEXT NOT NULL,
    "envKey" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "scopes" "ProjectApiKeyScope"[],

    CONSTRAINT "ProjectApiKey_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QrCode" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "displayConfigurationId" TEXT NOT NULL,
    "defaultCallbackUrl" TEXT,
    "pathExtension" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,

    CONSTRAINT "QrCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QrDisplayConfiguration" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "errorCorrectionLevel" "QrCodeErrorCorrectionLevel" NOT NULL DEFAULT E'M',
    "size" INTEGER NOT NULL DEFAULT 150,
    "frameSize" INTEGER NOT NULL DEFAULT 10,
    "backgroundColor" TEXT NOT NULL DEFAULT E'#FFFFFF',
    "foregroundColor" TEXT NOT NULL DEFAULT E'#000000',
    "logoImage" TEXT,
    "logoWidth" INTEGER NOT NULL DEFAULT 30,
    "logoHeight" INTEGER NOT NULL DEFAULT 30,
    "logoOpacity" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "removeQrCodeBehindLogo" BOOLEAN NOT NULL DEFAULT false,
    "dataStyle" "QrDataStyle" NOT NULL DEFAULT E'SQUARES',
    "locatorCornerRadii" JSONB NOT NULL DEFAULT '0',

    CONSTRAINT "QrDisplayConfiguration_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scan" (
    "id" TEXT NOT NULL,
    "scannedAt" TIMESTAMP(3) NOT NULL,
    "userAgent" TEXT,
    "ipAddress" TEXT,
    "headers" JSONB,
    "qrCodeId" TEXT NOT NULL,
    "registeredCodeScannerId" TEXT,
    "codeScannerTypeId" TEXT,
    "successfullyRedirected" BOOLEAN NOT NULL,
    "redirectUrl" TEXT,

    CONSTRAINT "Scan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CodeScannerType" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "identifierStoreMethod" "IdentifierStoreMethod" NOT NULL DEFAULT E'COOKIE',
    "inviteLink" TEXT,
    "isDefault" BOOLEAN NOT NULL DEFAULT true,
    "fallbackCallbackUrl" TEXT NOT NULL,
    "callbackUrls" JSONB NOT NULL,
    "projectId" TEXT NOT NULL,

    CONSTRAINT "CodeScannerType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RegisteredCodeScanner" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "typeId" TEXT NOT NULL,

    CONSTRAINT "RegisteredCodeScanner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Project" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "lastRequestedAt" TIMESTAMP(3),
    "lastGeneratedTokenAt" TIMESTAMP(3),
    "ownerId" TEXT NOT NULL,

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_accessToken_key" ON "User"("accessToken");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectApiKey_apiKey_key" ON "ProjectApiKey"("apiKey");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectApiKey_envKey_key" ON "ProjectApiKey"("envKey");

-- CreateIndex
CREATE UNIQUE INDEX "CodeScannerType_name_key" ON "CodeScannerType"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Project_ownerId_key" ON "Project"("ownerId");

-- AddForeignKey
ALTER TABLE "ProjectApiKey" ADD CONSTRAINT "ProjectApiKey_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QrCode" ADD CONSTRAINT "QrCode_displayConfigurationId_fkey" FOREIGN KEY ("displayConfigurationId") REFERENCES "QrDisplayConfiguration"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QrCode" ADD CONSTRAINT "QrCode_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scan" ADD CONSTRAINT "Scan_qrCodeId_fkey" FOREIGN KEY ("qrCodeId") REFERENCES "QrCode"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scan" ADD CONSTRAINT "Scan_codeScannerTypeId_fkey" FOREIGN KEY ("codeScannerTypeId") REFERENCES "CodeScannerType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scan" ADD CONSTRAINT "Scan_registeredCodeScannerId_fkey" FOREIGN KEY ("registeredCodeScannerId") REFERENCES "RegisteredCodeScanner"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CodeScannerType" ADD CONSTRAINT "CodeScannerType_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RegisteredCodeScanner" ADD CONSTRAINT "RegisteredCodeScanner_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "CodeScannerType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
