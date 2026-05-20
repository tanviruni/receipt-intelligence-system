import { Request, Response, NextFunction } from 'express';

/** Catches any error passed via next(err) and returns a consistent JSON shape. */
export function errorHandler(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
) {
  console.error('[error]', err.message);
  res.status(500).json({ error: err.message ?? 'Internal server error' });
}
