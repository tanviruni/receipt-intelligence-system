import { Request, Response, NextFunction } from 'express';
import { createReceipt } from './receipt.repository';

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
    const receipt = await createReceipt(imageUrl);

    res.status(201).json(receipt);
  } catch (err) {
    next(err);
  }
}
