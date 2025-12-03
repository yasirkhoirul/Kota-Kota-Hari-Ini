part of 'tambahkota_cubit.dart';

@immutable
sealed class TambahkotaState {}

final class TambahkotaInitial extends TambahkotaState {}
final class TambahKotaPickGambar extends TambahkotaState {
  final String? mimeType;
  final Uint8List? byte;

  TambahKotaPickGambar(this.mimeType, this.byte);

}
final class TambahkotaLoading extends TambahkotaState {}
final class TambahkotaLoadingUpGambar extends TambahkotaState {}
final class TambahkotaLOaded extends TambahkotaState {
  final String message;
  TambahkotaLOaded({required this.message});
}
final class TambahkotaError extends TambahkotaState {
  final String message;
  TambahkotaError({required this.message});
}
