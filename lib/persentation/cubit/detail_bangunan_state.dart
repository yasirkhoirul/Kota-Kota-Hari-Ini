part of 'detail_bangunan_cubit.dart';

@immutable
sealed class DetailBangunanState {}

final class DetailBangunanInitial extends DetailBangunanState {}
final class DetailBangunanLoading extends DetailBangunanState {}
final class DetailBangunanError extends DetailBangunanState {
  final String message;
  DetailBangunanError(this.message);
}
final class DetailBangunanLoaded extends DetailBangunanState {
  final List<DetailBangunanEntity> data;
  DetailBangunanLoaded(this.data);
}
