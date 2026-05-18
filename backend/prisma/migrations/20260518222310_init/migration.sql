-- CreateTable
CREATE TABLE "Receipt" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "imageUrl" TEXT NOT NULL,
    "rawOcrText" TEXT,
    "vendorName" TEXT,
    "date" TEXT,
    "totalAmount" REAL,
    "currency" TEXT DEFAULT 'EUR',
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "LineItem" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "receiptId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "price" REAL,
    "category" TEXT NOT NULL DEFAULT 'SONSTIGES',
    CONSTRAINT "LineItem_receiptId_fkey" FOREIGN KEY ("receiptId") REFERENCES "Receipt" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
