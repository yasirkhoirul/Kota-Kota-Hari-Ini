part of 'delete_kota_cubit.dart';

@immutable
sealed class DeleteKotaState {}

final class DeleteKotaInitial extends DeleteKotaState {}

final class DeleteKotaLoading extends DeleteKotaState {}

final class DeleteKotaError extends DeleteKotaState {
  final String message;
  DeleteKotaError(this.message);
}

final class DeleteKotaLoaded extends DeleteKotaState {
  final String message;
  DeleteKotaLoaded(this.message);
}
