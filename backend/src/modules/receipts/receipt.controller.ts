import { Request, Response, NextFunction } from 'express';
import {
  createReceipt,
  markReceiptFailed,
  updateReceiptWithParsedData,
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

    // 1. Save immediately as PENDING — fast response to client
    const receipt = await createReceipt(imageUrl);

    // 2. OCR runs in background — client polls for status
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

    // 3. Return PENDING receipt immediately
    res.status(201).json(receipt);
  } catch (err) {
    next(err);
  }
}
