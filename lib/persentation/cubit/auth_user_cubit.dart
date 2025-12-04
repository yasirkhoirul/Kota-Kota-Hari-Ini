import 'package:bloc/bloc.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_status_login.dart';
import 'package:kota_kota_hari_ini/domain/usecase/login.dart';
import 'package:kota_kota_hari_ini/domain/usecase/logout.dart';
import 'package:meta/meta.dart';

part 'auth_user_state.dart';

class AuthUserCubit extends Cubit<AuthUserState> {
  final GetStatusLogin getStatusLogin;
  final Login login;
  final Logout logout;
  AuthUserCubit(this.login, {required this.getStatusLogin, required this.logout}) : super(AuthUserInitial());

  void onlogin(String ur, String pw) async {
    emit(AuthUserLoading());
    try {
       await login.execute(ur, pw);
       await getstatuslogin();
    } catch (e) {
      emit(AuthUserError(e.toString()));
    }
  }

  void goinit(){
    emit(AuthUserInitial());
  }

  Future<bool> getstatuslogin()async{
    final data = await getStatusLogin.execute();
    if (data) {
      emit(AuthUserLoaded("", islogin: data));
    }
    return data;
  }

  void gologout()async{
     emit(AuthUserLoading());
    try {
      final data = await logout.execute();
      emit(AuthUserLoaded(data, islogin: false));
    } catch (e) {
      emit(AuthUserError(e.toString()));
    }
  }
}
