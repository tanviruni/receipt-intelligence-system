import 'dart:typed_data';
import '../entities/receipt.dart';
import '../entities/line_item.dart';

abstract class ReceiptRepository {
  /// Returns all receipts ordered by newest first.
  Future<List<Receipt>> getReceipts();

  /// Returns a single receipt with its line items.
  Future<Receipt> getReceiptById(String id);

  /// Uploads an image and creates a PENDING receipt.
  Future<Receipt> uploadReceipt(Uint8List bytes, String filename);

  /// Updates the category of a single line item.
  Future<LineItem> updateLineItemCategory(
    String receiptId,
    String itemId,
    String category,
  );

  /// Deletes a receipt and all its line items.
  Future<void> deleteReceipt(String id);
}
