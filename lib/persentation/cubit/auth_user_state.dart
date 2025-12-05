part of 'auth_user_cubit.dart';

@immutable
sealed class AuthUserState {}

final class AuthUserInitial extends AuthUserState {}

final class AuthUserLoading extends AuthUserState {}

final class AuthUserError extends AuthUserState {
  final String message;
  AuthUserError(this.message);
}

final class AuthUserLoaded extends AuthUserState {
  final String message;
  final bool islogin;
  AuthUserLoaded(this.message, {required this.islogin});
}
