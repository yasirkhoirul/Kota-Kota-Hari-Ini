part of 'add_bangunan_cubit.dart';

@immutable
sealed class AddBangunanState {}

final class AddBangunanInitial extends AddBangunanState {}
final class AddBangunanLoading extends AddBangunanState {}
final class AddBangunanSuccess extends AddBangunanState {}
final class AddBangunanError extends AddBangunanState {
  final String message;
  AddBangunanError(this.message);
}