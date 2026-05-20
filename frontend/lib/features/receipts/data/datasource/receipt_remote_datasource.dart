import 'dart:typed_data';
import 'package:dio/dio.dart';

import '../models/receipt_model.dart';
import '../models/line_item_model.dart';

class ReceiptRemoteDatasource {
  const ReceiptRemoteDatasource(this._dio);

  final Dio _dio;

  Future<List<ReceiptModel>> getReceipts() async {
    final response = await _dio.get<List<dynamic>>('/receipts');
    return response.data!
        .map((e) => ReceiptModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ReceiptModel> getReceiptById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/receipts/$id');
    return ReceiptModel.fromJson(response.data!);
  }

  /// Uploads a receipt image as multipart/form-data.
  /// Throws a readable Exception on 409 (duplicate image).
  Future<ReceiptModel> uploadReceipt(Uint8List bytes, String filename) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: DioMediaType(
            'image',
            filename.toLowerCase().endsWith('.png') ? 'png' : 'jpeg',
          ),
        ),
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '/receipts',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return ReceiptModel.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('This receipt has already been uploaded.');
      }
      rethrow;
    }
  }

  Future<LineItemModel> updateLineItemCategory(
    String receiptId,
    String itemId,
    String category,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/receipts/$receiptId/items/$itemId',
      data: {'category': category},
    );
    return LineItemModel.fromJson(response.data!);
  }

  Future<void> deleteReceipt(String id) async {
    await _dio.delete('/receipts/$id');
  }
}
