import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login {
  final KotaRepository kotaRepository;
  const Login(this.kotaRepository);

  Future<Session> execute(String ur, String pw){
    return kotaRepository.login(ur, pw);
  }
}