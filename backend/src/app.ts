import express from 'express';
import cors from 'cors';
import path from 'path';
import receiptRoutes from './modules/receipts/receipt.routes';
import { errorHandler } from './middleware/error';

export function createApp() {
  const app = express();

  app.use(cors());
  app.use(express.json());

  // Serve uploaded receipt images as static files
  app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));

  app.get('/health', (_req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
  });

  app.use('/receipts', receiptRoutes);

  app.use((_req, res) => {
    res.status(404).json({ error: 'Not found' });
  });

  app.use(errorHandler);

  return app;
}
