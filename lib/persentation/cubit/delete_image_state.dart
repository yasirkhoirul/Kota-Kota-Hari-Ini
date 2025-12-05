part of 'delete_image_cubit.dart';

@immutable
sealed class DeleteImageState {}

final class DeleteImageInitial extends DeleteImageState {}

final class DeleteImageLoading extends DeleteImageState {}

final class DeleteImageError extends DeleteImageState {
  final String message;
  DeleteImageError(this.message);
}

final class DeleteImageLoaded extends DeleteImageState {
  final String message;
  DeleteImageLoaded(this.message);
}
