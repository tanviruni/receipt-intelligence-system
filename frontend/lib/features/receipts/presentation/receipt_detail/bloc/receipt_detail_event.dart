part of 'receipt_detail_bloc.dart';

abstract class ReceiptDetailEvent extends Equatable {
  const ReceiptDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered on page init — fetches the receipt by id.
class ReceiptDetailLoaded extends ReceiptDetailEvent {
  const ReceiptDetailLoaded({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Triggered when user changes a line item category via the dropdown.
class ReceiptDetailCategoryUpdated extends ReceiptDetailEvent {
  const ReceiptDetailCategoryUpdated({
    required this.receiptId,
    required this.itemId,
    required this.category,
  });

  final String receiptId;
  final String itemId;
  final String category;

  @override
  List<Object?> get props => [receiptId, itemId, category];
}
