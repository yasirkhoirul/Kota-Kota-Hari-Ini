part of 'bangunan_kota_cubit.dart';

@immutable
sealed class BangunanKotaState {}

final class BangunanKotaInitial extends BangunanKotaState {}
final class BangunanKotaLoading extends BangunanKotaState {}
final class BangunanKotaError extends BangunanKotaState {
  final String message;
  BangunanKotaError(this.message);
}
final class BangunanKotaLoaded extends BangunanKotaState {
  final List<BangunanEntity> data;
  BangunanKotaLoaded(this.data);
}
