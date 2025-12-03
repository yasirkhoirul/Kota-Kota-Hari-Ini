part of 'search_kota_cubit.dart';

@immutable
class SearchKotaState {}

final class SearchKotaInitial extends SearchKotaState {}
final class SearchKotaLoading extends SearchKotaState {}
final class SearchKotaLoaded extends SearchKotaState {
  final List<KotaEntity> data;
  SearchKotaLoaded(this.data);
}
final class SearchKotaError extends SearchKotaState {
  final String message;
  SearchKotaError(this.message);
}
