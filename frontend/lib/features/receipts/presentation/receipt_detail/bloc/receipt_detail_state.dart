part of 'receipt_detail_bloc.dart';

abstract class ReceiptDetailState extends Equatable {
  const ReceiptDetailState();

  @override
  List<Object?> get props => [];
}

class ReceiptDetailInitial extends ReceiptDetailState {
  const ReceiptDetailInitial();
}

class ReceiptDetailLoading extends ReceiptDetailState {
  const ReceiptDetailLoading();
}

class ReceiptDetailSuccess extends ReceiptDetailState {
  const ReceiptDetailSuccess({required this.receipt});

  final Receipt receipt;

  @override
  List<Object?> get props => [receipt];
}

class ReceiptDetailFailure extends ReceiptDetailState {
  const ReceiptDetailFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
