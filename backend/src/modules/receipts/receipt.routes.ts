import { Router } from 'express';
import { upload } from '../../middleware/upload';
import {
  uploadReceipt,
  getReceipts,
  getReceiptById,
  patchLineItemCategory,
  removeReceipt,
} from './receipt.controller';

const router = Router();

router.get('/', getReceipts);
router.post('/', upload.single('image'), uploadReceipt);
router.get('/:id', getReceiptById);
router.patch('/:id/items/:itemId', patchLineItemCategory);
router.delete('/:id', removeReceipt);

export default router;
