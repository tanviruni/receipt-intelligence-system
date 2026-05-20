import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/receipt.dart';
import '../../../domain/repositories/receipt_repository.dart';

part 'receipt_list_event.dart';
part 'receipt_list_state.dart';

class ReceiptListBloc extends Bloc<ReceiptListEvent, ReceiptListState> {
  ReceiptListBloc({required ReceiptRepository repository})
    : _repository = repository,
      super(const ReceiptListInitial()) {
    on<ReceiptListLoaded>(_onLoaded);
    on<ReceiptListRefreshed>(_onRefreshed);
    on<ReceiptListItemDeleted>(_onDeleted);
  }

  final ReceiptRepository _repository;

  Future<void> _onLoaded(
    ReceiptListLoaded event,
    Emitter<ReceiptListState> emit,
  ) async {
    emit(const ReceiptListLoading());
    try {
      final receipts = await _repository.getReceipts();
      emit(ReceiptListSuccess(receipts: receipts));
    } catch (e) {
      emit(ReceiptListFailure(message: e.toString()));
    }
  }

  Future<void> _onRefreshed(
    ReceiptListRefreshed event,
    Emitter<ReceiptListState> emit,
  ) async {
    try {
      final receipts = await _repository.getReceipts();
      emit(ReceiptListSuccess(receipts: receipts));
    } catch (e) {
      emit(ReceiptListFailure(message: e.toString()));
    }
  }

  Future<void> _onDeleted(
    ReceiptListItemDeleted event,
    Emitter<ReceiptListState> emit,
  ) async {
    try {
      await _repository.deleteReceipt(event.id);
      final receipts = await _repository.getReceipts();
      emit(ReceiptListSuccess(receipts: receipts));
    } catch (e) {
      emit(ReceiptListFailure(message: e.toString()));
    }
  }
}
