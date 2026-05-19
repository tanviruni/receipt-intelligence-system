import { Request, Response, NextFunction } from 'express';
import { createReceipt, markReceiptFailed, updateReceiptOcrText } from './receipt.repository';
import { extractText } from '../../services/ocr/ocr.service';

export async function uploadReceipt(
  req: Request,
  res: Response,
  next: NextFunction,
) {
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
        if (rawOcrText) {
          await updateReceiptOcrText(receipt.id, rawOcrText);
        } else {
          await markReceiptFailed(receipt.id);
        }
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