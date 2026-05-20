import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/receipt.dart';
import '../../../domain/repositories/receipt_repository.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc({required ReceiptRepository repository})
    : _repository = repository,
      super(const UploadInitial()) {
    on<UploadSubmitted>(_onSubmitted);
  }

  final ReceiptRepository _repository;

  Future<void> _onSubmitted(
    UploadSubmitted event,
    Emitter<UploadState> emit,
  ) async {
    emit(const UploadInProgress());
    try {
      final receipt = await _repository.uploadReceipt(
        event.bytes,
        event.filename,
      );
      emit(UploadSuccess(receipt: receipt));
    } catch (e) {
      emit(UploadFailure(message: e.toString()));
    }
  }
}
