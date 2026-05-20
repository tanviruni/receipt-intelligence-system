import { Request, Response, NextFunction } from 'express';
import {
  createReceipt,
  markReceiptFailed,
  updateReceiptWithParsedData,
  findAllReceipts,
  findReceiptById,
  updateLineItemCategory,
  deleteReceipt,
} from './receipt.repository';
import { extractText } from '../../services/ocr/ocr.service';
import { parseReceipt } from '../../services/parsing/parsing.service';

/**
 * POST /receipts
 * Accepts a receipt image, saves it to disk, and immediately returns a
 * PENDING record. OCR and parsing run in the background — the client
 * should poll GET /receipts/:id until status is DONE or FAILED.
 */
export async function uploadReceipt(req: Request, res: Response, next: NextFunction) {
  try {
    if (!req.file) {
      res.status(400).json({ error: 'No image file provided' });
      return;
    }

    const imageUrl = `/uploads/${req.file.filename}`;
    const receipt = await createReceipt(imageUrl);

    extractText(req.file.filename)
      .then(async (rawOcrText) => {
        if (!rawOcrText) {
          await markReceiptFailed(receipt.id);
          return;
        }
        const parsed = parseReceipt(rawOcrText);
        await updateReceiptWithParsedData(receipt.id, rawOcrText, parsed);
      })
      .catch(async () => {
        await markReceiptFailed(receipt.id);
      });

    res.status(201).json(receipt);
  } catch (err) {
    next(err);
  }
}

/** GET /receipts — returns all receipts, newest first, without line items. */
export async function getReceipts(_req: Request, res: Response, next: NextFunction) {
  try {
    const receipts = await findAllReceipts();
    res.json(receipts);
  } catch (err) {
    next(err);
  }
}

/** GET /receipts/:id — returns a single receipt with its line items. */
export async function getReceiptById(req: Request, res: Response, next: NextFunction) {
  try {
    const receipt = await findReceiptById(req.params['id']!);
    if (!receipt) {
      res.status(404).json({ error: 'Receipt not found' });
      return;
    }
    res.json(receipt);
  } catch (err) {
    next(err);
  }
}

/** PATCH /receipts/:receiptId/items/:itemId
 *  Updates the category of one line item. Validates against allowed values. */
export async function patchLineItemCategory(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  try {
    const { category } = req.body as { category: string };

    const VALID_CATEGORIES = [
      'LEBENSMITTEL',
      'HAUSHALT',
      'GASTRONOMIE',
      'GESUNDHEIT',
      'ELEKTRONIK',
      'SONSTIGES',
    ];

    if (!category || !VALID_CATEGORIES.includes(category)) {
      res.status(400).json({
        error: `category must be one of: ${VALID_CATEGORIES.join(', ')}`,
      });
      return;
    }

    const item = await updateLineItemCategory(req.params['itemId']!, category);
    res.json(item);
  } catch (err) {
    next(err);
  }
}

/** DELETE /receipts/:id — deletes a receipt and all its line items. */
export async function removeReceipt(req: Request, res: Response, next: NextFunction) {
  try {
    await deleteReceipt(req.params['id']!);
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}
