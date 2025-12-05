part of 'update_kota_cubit.dart';

@immutable
sealed class UpdateKotaState {}

final class UpdateKotaInitial extends UpdateKotaState {}

final class UpdateKotaLoading extends UpdateKotaState {}

final class UpdateKotaError extends UpdateKotaState {
  final String message;
  UpdateKotaError(this.message);
}

final class UpdateKotaLoaded extends UpdateKotaState {
  final String message;
  UpdateKotaLoaded(this.message);
}
