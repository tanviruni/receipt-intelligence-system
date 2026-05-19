/**
 * Parsing service — extracts structured data from raw OCR text.
 *
 * Uploaded receipts may be messy and inconsistent across vendors.
 * Each extractor is a pure function so it can be tested in isolation.
 * Fields that cannot be extracted are returned as null — never invented.
 */

export interface ParsedLineItem {
  name: string;
  price: number | null;
}

export interface ParsedReceipt {
  vendorName: string | null;
  date: string | null;
  totalAmount: number | null;
  currency: string;
  items: ParsedLineItem[];
}

// ─── Patterns ────────────────────────────────────────────────────────────────

// Matches German dates: 18.05.2026 / 18.05.26 / 18/05/2026
const DATE_PATTERN = /\b(\d{2}[./]\d{2}[./]\d{2,4})\b/;

// Matches a price at the end of a line: 1,29 / 12.99 / 1.234,56
const PRICE_AT_END = /(\d{1,3}(?:[.,]\d{3})*[.,]\d{2})\s*[A-Z]?\s*$/;

// Lines that indicate the total amount
const TOTAL_KEYWORDS =
  /\b(summe|gesamt|total|zu\s?zahlen|gesamtbetrag|endbetrag|bar|ec)\b/i;

// Lines to ignore entirely — tax rows, separators, footers
const NOISE_PATTERN =
  /^\s*$|^[-=*#_]{2,}|mwst|ust\.\s*\d|steuer|\d+\s*%|bon.?nr|kassen|filial|tel[.:]|www\.|http|danke|auf\s+wieder|tse|karte|pin|trace/i;

// ─── Helpers ─────────────────────────────────────────────────────────────────

/**
 * Convert a German-formatted price string to a float.
 * "1.234,56" → 1234.56 / "12,99" → 12.99 / "12.99" → 12.99
 */
function parseGermanPrice(raw: string): number | null {
  // Determine if comma or dot is the decimal separator
  const commaIndex = raw.lastIndexOf(',');
  const dotIndex = raw.lastIndexOf('.');

  let normalised: string;

  if (commaIndex > dotIndex) {
    // German format: 1.234,56
    normalised = raw.replace(/\./g, '').replace(',', '.');
  } else {
    // Already dot-decimal: 12.99
    normalised = raw.replace(/,/g, '');
  }

  const value = parseFloat(normalised);
  return isNaN(value) ? null : value;
}

function splitLines(text: string): string[] {
  return text
    .split('\n')
    .map((l) => l.trim())
    .filter((l) => l.length > 0);
}

// ─── Extractors ───────────────────────────────────────────────────────────────

/**
 * Vendor name: the first meaningful line of the receipt.
 * Skip very short lines and lines that look like addresses or numbers.
 */
function extractVendor(lines: string[]): string | null {
  for (const line of lines.slice(0, 6)) {
    if (line.length < 3) continue;
    if (/^\d+$/.test(line)) continue; // pure number
    if (/^(str\.|straße|platz|weg\s|\d{5})/i.test(line)) continue; // address
    return line;
  }
  return null;
}

/**
 * Date: first pattern match anywhere in the text.
 */
function extractDate(text: string): string | null {
  const match = text.match(DATE_PATTERN);
  return match ? match[1] : null;
}

/**
 * Total: scan lines for total keywords, then extract the price on that line.
 * Falls back to the largest price found if no keyword matches.
 */
function extractTotal(lines: string[]): number | null {
  // First pass — look for explicit total keyword
  for (const line of lines) {
    if (TOTAL_KEYWORDS.test(line)) {
      const match = line.match(PRICE_AT_END);
      if (match) return parseGermanPrice(match[1]);
    }
  }

  // Fallback — return the largest price on any line
  let largest: number | null = null;
  for (const line of lines) {
    const match = line.match(PRICE_AT_END);
    if (match) {
      const value = parseGermanPrice(match[1]);
      if (value !== null && (largest === null || value > largest)) {
        largest = value;
      }
    }
  }
  return largest;
}

/**
 * Line items: lines that have a price at the end and are not noise.
 * Strips the price from the name.
 */
function extractLineItems(lines: string[]): ParsedLineItem[] {
  const items: ParsedLineItem[] = [];

  for (const line of lines) {
    if (NOISE_PATTERN.test(line)) continue;
    if (TOTAL_KEYWORDS.test(line)) continue;

    const match = line.match(PRICE_AT_END);
    if (!match) continue;

    const price = parseGermanPrice(match[1]);
    // Remove the price portion from the end to get the item name
    const name = line.slice(0, line.lastIndexOf(match[1])).trim();

    if (name.length < 2) continue; // skip if nothing meaningful left

    items.push({ name, price });
  }

  return items;
}

// ─── Public API ───────────────────────────────────────────────────────────────

export function parseReceipt(rawOcrText: string): ParsedReceipt {
  const lines = splitLines(rawOcrText);

  return {
    vendorName: extractVendor(lines),
    date: extractDate(rawOcrText),
    totalAmount: extractTotal(lines),
    currency: 'EUR',
    items: extractLineItems(lines),
  };
}
