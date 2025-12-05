part of 'upload_page_dart_cubit.dart';

@immutable
sealed class UploadPageDartState {}

final class UploadPageDartInitial extends UploadPageDartState {}

final class UploadPageDartLoading extends UploadPageDartState {}

final class UploadPageDartError extends UploadPageDartState {
  final String message;
  UploadPageDartError(this.message);
}

final class UploadPageDartLoaded extends UploadPageDartState {
  final Uint8List? imageBytes;
  final String? fileName; // Simpan nama file original atau generate baru
  final String? mimeType;

  UploadPageDartLoaded({this.imageBytes, this.fileName, this.mimeType});
}

final class UploadPageDartSuccess extends UploadPageDartState {
  final String message;
  UploadPageDartSuccess(this.message);
}
