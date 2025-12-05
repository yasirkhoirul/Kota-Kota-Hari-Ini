import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class Logout {
  final KotaRepository kotaRepository;
  const Logout(this.kotaRepository);

  Future<String> execute() {
    return kotaRepository.logout();
  }
}
