part of 'receipt_list_bloc.dart';

abstract class ReceiptListState extends Equatable {
  const ReceiptListState();

  @override
  List<Object?> get props => [];
}

class ReceiptListInitial extends ReceiptListState {
  const ReceiptListInitial();
}

class ReceiptListLoading extends ReceiptListState {
  const ReceiptListLoading();
}

class ReceiptListSuccess extends ReceiptListState {
  const ReceiptListSuccess({required this.receipts});

  final List<Receipt> receipts;

  @override
  List<Object?> get props => [receipts];
}

class ReceiptListFailure extends ReceiptListState {
  const ReceiptListFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
