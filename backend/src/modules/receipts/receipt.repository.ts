import { prisma } from '../../db/client';
import { ParsedReceipt } from '../../services/parsing/parsing.service';
import { categorise } from '../../services/categorisation/categorisation.service';

/** Creates a new receipt record with PENDING status immediately after upload. */
export async function createReceipt(imageUrl: string) {
  return prisma.receipt.create({
    data: { imageUrl, status: 'PENDING' },
    include: { items: true },
  });
}

/** Stores the raw OCR text without parsed fields. Kept for backwards compatibility. */
export async function updateReceiptOcrText(id: string, rawOcrText: string) {
  return prisma.receipt.update({
    where: { id },
    data: { rawOcrText, status: 'DONE' },
    include: { items: true },
  });
}

/** Marks a receipt as FAILED when OCR returns empty or throws. */
export async function markReceiptFailed(id: string) {
  return prisma.receipt.update({
    where: { id },
    data: { status: 'FAILED' },
  });
}

/**
 * Updates a receipt with the raw OCR text and all parsed fields.
 * Creates line items in the same transaction via Prisma's nested write.
 * Called after OCR and parsing complete successfully.
 */
export async function updateReceiptWithParsedData(
  id: string,
  rawOcrText: string,
  parsed: ParsedReceipt,
) {
  return prisma.receipt.update({
    where: { id },
    data: {
      rawOcrText,
      vendorName: parsed.vendorName,
      date: parsed.date,
      totalAmount: parsed.totalAmount,
      currency: parsed.currency,
      status: 'DONE',
      items: {
        create: parsed.items.map((item) => ({
          name: item.name,
          price: item.price,
          category: categorise(item.name),
        })),
      },
    },
    include: { items: true },
  });
}
