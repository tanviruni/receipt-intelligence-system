part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when user confirms the upload with a selected file.
class UploadSubmitted extends UploadEvent {
  const UploadSubmitted({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;

  @override
  List<Object?> get props => [filename];
}
