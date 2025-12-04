part of 'detail_kota_dart_cubit.dart';

@immutable
sealed class DetailKotaDartState {}

final class DetailKotaDartInitial extends DetailKotaDartState {}
final class DetailKotaDartLoading extends DetailKotaDartState {}
final class DetailKotaDartError extends DetailKotaDartState {
  final String message;
  DetailKotaDartError(this.message);
}
final class DetailKotaDartLoaded extends DetailKotaDartState {
  final KotaEntity data;
  DetailKotaDartLoaded(this.data);
}
