import '../../domain/entities/line_item.dart';

class LineItemModel extends LineItem {
  const LineItemModel({
    required super.id,
    required super.receiptId,
    required super.name,
    required super.category,
    super.price,
  });

  factory LineItemModel.fromJson(Map<String, dynamic> json) {
    return LineItemModel(
      id: json['id'] as String,
      receiptId: json['receiptId'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'SONSTIGES',
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}
