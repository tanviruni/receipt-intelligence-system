class LineItem {
  const LineItem({
    required this.id,
    required this.receiptId,
    required this.name,
    required this.category,
    this.price,
  });

  final String id;
  final String receiptId;
  final String name;
  final String category;
  final double? price;
}
