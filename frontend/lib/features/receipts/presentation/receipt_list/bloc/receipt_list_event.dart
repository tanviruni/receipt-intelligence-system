part of 'receipt_list_bloc.dart';

abstract class ReceiptListEvent extends Equatable {
  const ReceiptListEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered on page init — loads all receipts from the API.
class ReceiptListLoaded extends ReceiptListEvent {
  const ReceiptListLoaded();
}

/// Triggered after a successful upload to refresh the list.
class ReceiptListRefreshed extends ReceiptListEvent {
  const ReceiptListRefreshed();
}

/// Triggered when user deletes a receipt.
class ReceiptListItemDeleted extends ReceiptListEvent {
  const ReceiptListItemDeleted({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
