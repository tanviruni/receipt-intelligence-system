import { prisma } from '../../db/client';

export async function createReceipt(imageUrl: string) {
  return prisma.receipt.create({
    data: { imageUrl, status: 'PENDING' },
    include: { items: true },
  });
}
