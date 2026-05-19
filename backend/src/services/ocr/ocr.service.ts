import Tesseract from 'tesseract.js';
import sharp from 'sharp';
import path from 'path';
import fs from 'fs/promises';

const UPLOAD_DIR = path.join(process.cwd(), 'uploads');

/**
 * Preprocess the image with sharp before OCR:
 * - convert to greyscale (removes colour noise)
 * - increase contrast (makes text sharper)
 * - output as PNG (lossless, better for OCR than JPEG)
 */
async function preprocessImage(filename: string): Promise<Buffer> {
  const filePath = path.join(UPLOAD_DIR, filename);
  const fileExists = await fs
    .access(filePath)
    .then(() => true)
    .catch(() => false);

  if (!fileExists) {
    throw new Error(`Image file not found: ${filename}`);
  }

  return sharp(filePath)
    .greyscale()
    .normalise() // auto contrast
    .toBuffer();
}

/**
 * Extract raw text from a receipt image.
 * Returns an empty string if OCR fails — the pipeline continues
 * with whatever it could extract rather than crashing.
 */
export async function extractText(filename: string): Promise<string> {
  try {
    const imageBuffer = await preprocessImage(filename);

    const { data } = await Tesseract.recognize(imageBuffer, 'deu+eng', {
      // uncomment to see Tesseract progress in the console during development
      // logger: (m) => console.log('[ocr]', m.status, m.progress),
    });

    return data.text.trim();
  } catch (err) {
    console.error('[ocr] extraction failed:', err);
    return '';
  }
}
