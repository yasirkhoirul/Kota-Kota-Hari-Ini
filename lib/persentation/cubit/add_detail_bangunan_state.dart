part of 'add_detail_bangunan_cubit.dart';

@immutable
sealed class AddDetailBangunanState {}

class AddDetailInitial extends AddDetailBangunanState {}
class AddDetailLoading extends AddDetailBangunanState {}
class AddDetailSuccess extends AddDetailBangunanState {}
class AddDeleteSuccess extends AddDetailBangunanState {}
class AddDetailError extends AddDetailBangunanState {
  final String message;
  AddDetailError(this.message);
}