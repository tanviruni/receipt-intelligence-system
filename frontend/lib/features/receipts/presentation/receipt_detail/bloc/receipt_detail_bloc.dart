import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/receipt.dart';
import '../../../domain/repositories/receipt_repository.dart';

part 'receipt_detail_event.dart';
part 'receipt_detail_state.dart';

class ReceiptDetailBloc extends Bloc<ReceiptDetailEvent, ReceiptDetailState> {
  ReceiptDetailBloc({required ReceiptRepository repository})
    : _repository = repository,
      super(const ReceiptDetailInitial()) {
    on<ReceiptDetailLoaded>(_onLoaded);
    on<ReceiptDetailCategoryUpdated>(_onCategoryUpdated);
  }

  final ReceiptRepository _repository;

  Future<void> _onLoaded(
    ReceiptDetailLoaded event,
    Emitter<ReceiptDetailState> emit,
  ) async {
    emit(const ReceiptDetailLoading());
    try {
      final receipt = await _repository.getReceiptById(event.id);
      emit(ReceiptDetailSuccess(receipt: receipt));
    } catch (e) {
      emit(ReceiptDetailFailure(message: e.toString()));
    }
  }

  Future<void> _onCategoryUpdated(
    ReceiptDetailCategoryUpdated event,
    Emitter<ReceiptDetailState> emit,
  ) async {
    try {
      await _repository.updateLineItemCategory(
        event.receiptId,
        event.itemId,
        event.category,
      );
      // Reload to reflect the saved change
      final receipt = await _repository.getReceiptById(event.receiptId);
      emit(ReceiptDetailSuccess(receipt: receipt));
    } catch (e) {
      emit(ReceiptDetailFailure(message: e.toString()));
    }
  }
}
