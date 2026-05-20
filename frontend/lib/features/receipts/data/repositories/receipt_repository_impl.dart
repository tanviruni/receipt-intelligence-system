import 'dart:typed_data';

import '../../domain/entities/receipt.dart';
import '../../domain/entities/line_item.dart';
import '../../domain/repositories/receipt_repository.dart';
import '../datasource/receipt_remote_datasource.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  const ReceiptRepositoryImpl(this._datasource);

  final ReceiptRemoteDatasource _datasource;

  @override
  Future<List<Receipt>> getReceipts() => _datasource.getReceipts();

  @override
  Future<Receipt> getReceiptById(String id) => _datasource.getReceiptById(id);

  @override
  Future<Receipt> uploadReceipt(Uint8List bytes, String filename) =>
      _datasource.uploadReceipt(bytes, filename);

  @override
  Future<LineItem> updateLineItemCategory(
    String receiptId,
    String itemId,
    String category,
  ) => _datasource.updateLineItemCategory(receiptId, itemId, category);

  @override
  Future<void> deleteReceipt(String id) => _datasource.deleteReceipt(id);
}
