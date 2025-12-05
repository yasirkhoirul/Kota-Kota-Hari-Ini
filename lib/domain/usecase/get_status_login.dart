import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class GetStatusLogin {
  final KotaRepository kotaRepository;
  const GetStatusLogin(this.kotaRepository);

  Future<bool> execute() {
    return kotaRepository.ceklogin();
  }
}
