part of 'upload_bloc.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {
  const UploadInitial();
}

class UploadInProgress extends UploadState {
  const UploadInProgress();
}

class UploadSuccess extends UploadState {
  const UploadSuccess({required this.receipt});

  final Receipt receipt;

  @override
  List<Object?> get props => [receipt];
}

class UploadFailure extends UploadState {
  const UploadFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
