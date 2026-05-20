import '../../domain/entities/receipt.dart';
import 'line_item_model.dart';

class ReceiptModel extends Receipt {
  const ReceiptModel({
    required super.id,
    required super.imageUrl,
    required super.status,
    required super.currency,
    required super.createdAt,
    super.vendorName,
    super.date,
    super.totalAmount,
    super.rawOcrText,
    super.items,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      status: json['status'] as String,
      currency: json['currency'] as String? ?? 'EUR',
      createdAt: json['createdAt'] as String,
      vendorName: json['vendorName'] as String?,
      date: json['date'] as String?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      rawOcrText: json['rawOcrText'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => LineItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
