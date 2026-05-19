import { prisma } from '../../db/client';

export async function createReceipt(imageUrl: string) {
  return prisma.receipt.create({
    data: { imageUrl, status: 'PENDING' },
    include: { items: true },
  });
}

export async function updateReceiptOcrText(id: string, rawOcrText: string) {
  return prisma.receipt.update({
    where: { id },
    data: { rawOcrText, status: 'DONE' },
    include: { items: true },
  });
}

export async function markReceiptFailed(id: string) {
  return prisma.receipt.update({
    where: { id },
    data: { status: 'FAILED' },
  });
}