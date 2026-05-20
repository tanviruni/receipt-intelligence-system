import 'line_item.dart';

class Receipt {
  const Receipt({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.currency,
    required this.createdAt,
    this.vendorName,
    this.date,
    this.totalAmount,
    this.rawOcrText,
    this.items = const [],
  });

  final String id;
  final String imageUrl;
  final String status; // PENDING | DONE | FAILED
  final String currency;
  final String createdAt;
  final String? vendorName;
  final String? date;
  final double? totalAmount;
  final String? rawOcrText;
  final List<LineItem> items;
}
