part of 'loader_asset_cubit.dart';

@immutable
class LoaderAssetState {}

final class LoaderAssetInitial extends LoaderAssetState {}
final class LoaderAssetLoading extends LoaderAssetState {}
final class LoaderAssetError extends LoaderAssetState {
  final String message;
  LoaderAssetError(this.message);
}
final class LoaderAssetLoaded extends LoaderAssetState {
  final String message;
  LoaderAssetLoaded(this.message);
}
