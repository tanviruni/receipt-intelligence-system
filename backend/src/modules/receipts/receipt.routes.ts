import { Router } from 'express';
import { upload } from '../../middleware/upload';
import { uploadReceipt } from './receipt.controller';

const router = Router();

// POST /receipts — accepts a receipt image, creates a PENDING receipt record
router.post('/', upload.single('image'), uploadReceipt);

export default router;
