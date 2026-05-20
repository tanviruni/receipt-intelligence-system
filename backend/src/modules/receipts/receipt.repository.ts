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

/** Marks a receipt as FAILED when OCR returns empty or throws. */
export async function markReceiptFailed(id: string) {
  return prisma.receipt.update({
    where: { id },
    data: { status: 'FAILED' },
  });
}

/**
 * Updates a receipt with raw OCR text and all parsed fields.
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

/** Returns all receipts ordered by newest first, without line items. */
export async function findAllReceipts() {
  return prisma.receipt.findMany({
    orderBy: { createdAt: 'desc' },
  });
}

/** Returns a single receipt with its line items, or null if not found. */
export async function findReceiptById(id: string) {
  return prisma.receipt.findUnique({
    where: { id },
    include: { items: true },
  });
}

/** Updates the category of a single line item.
 *  Called when the user manually corrects a category in the UI. */
export async function updateLineItemCategory(id: string, category: string) {
  return prisma.lineItem.update({
    where: { id },
    data: { category },
  });
}

/** Deletes a receipt and all its line items via cascading delete. */
export async function deleteReceipt(id: string) {
  return prisma.receipt.delete({ where: { id } });
}
