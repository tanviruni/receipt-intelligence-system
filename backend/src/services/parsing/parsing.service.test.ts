import { parseReceipt } from './parsing.service';
import { describe, expect, it } from '@jest/globals';

describe('parseReceipt', () => {
  describe('extractVendor', () => {
    it('returns the first meaningful line as vendor name', () => {
      const text = `REWE Markt GmbH\nMusterstraße 1\n12345 Berlin\n12.03.2024\nMilch 1L    1,29 B\nGESAMT    1,29`;
      const result = parseReceipt(text);
      expect(result.vendorName).toBe('REWE Markt GmbH');
    });

    it('skips short lines and returns the next meaningful one', () => {
      const text = `**\nALDI SUD\nMusterstr. 5\n10.05.2024\nBrot    0,99`;
      const result = parseReceipt(text);
      expect(result.vendorName).toBe('ALDI SUD');
    });

    it('returns null when no meaningful vendor line exists', () => {
      const text = `\n\n12345\n`;
      const result = parseReceipt(text);
      expect(result.vendorName).toBeNull();
    });
  });

  describe('extractDate', () => {
    it('extracts a German dot-separated date', () => {
      const text = `REWE\n18.05.2026\nMilch 1,29`;
      const result = parseReceipt(text);
      expect(result.date).toBe('18.05.2026');
    });

    it('extracts a two-digit year date', () => {
      const text = `ALDI\n15.10.24\nBrot 0,99`;
      const result = parseReceipt(text);
      expect(result.date).toBe('15.10.24');
    });

    it('returns null when no date is present', () => {
      const text = `REWE\nMilch 1,29\nGESAMT 1,29`;
      const result = parseReceipt(text);
      expect(result.date).toBeNull();
    });
  });

  describe('extractTotal', () => {
    it('extracts total from a line with GESAMT keyword', () => {
      const text = `REWE\n18.05.2026\nMilch    1,29 B\nBrot     0,99 B\nGESAMT   2,28`;
      const result = parseReceipt(text);
      expect(result.totalAmount).toBe(2.28);
    });

    it('extracts total from a line with SUMME keyword', () => {
      const text = `ALDI\nJoghurt  0,79\nSUMME    0,79`;
      const result = parseReceipt(text);
      expect(result.totalAmount).toBe(0.79);
    });

    it('falls back to the largest price when no keyword matches', () => {
      const text = `DM Drogerie\nShampoo   3,99\nZahnpasta 1,49`;
      const result = parseReceipt(text);
      expect(result.totalAmount).toBe(3.99);
    });

    it('correctly parses German comma-decimal format', () => {
      const text = `REWE\nGESAMT   12,99`;
      const result = parseReceipt(text);
      expect(result.totalAmount).toBe(12.99);
    });

    it('returns null when no prices are found', () => {
      const text = `REWE\n18.05.2026\nKeine Preise hier`;
      const result = parseReceipt(text);
      expect(result.totalAmount).toBeNull();
    });
  });

  describe('extractLineItems', () => {
    it('extracts line items with name and price', () => {
      const text = `REWE\nMilch 1L    1,29 B\nBrot        0,99 B\nGESAMT      2,28`;
      const result = parseReceipt(text);
      expect(result.items.length).toBeGreaterThan(0);
      expect(result.items[0].price).toBe(1.29);
    });

    it('filters out noise lines like MwSt and separators', () => {
      const text = `REWE\nMilch 1L    1,29 B\nMwSt 19%    0,21\n---\nGESAMT      1,29`;
      const result = parseReceipt(text);
      const names = result.items.map((i) => i.name);
      expect(names).not.toContain(expect.stringMatching(/mwst/i));
    });

    it('returns empty array when no line items are found', () => {
      const text = `REWE\n18.05.2026\nKein Einkauf`;
      const result = parseReceipt(text);
      expect(result.items).toEqual([]);
    });
  });

  describe('currency', () => {
    it('always returns EUR', () => {
      const result = parseReceipt('REWE\nMilch 1,29');
      expect(result.currency).toBe('EUR');
    });
  });
});
