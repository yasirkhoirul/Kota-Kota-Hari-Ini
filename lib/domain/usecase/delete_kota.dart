import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class DeleteKota {
  final KotaRepository kotaRepository;
  const DeleteKota(this.kotaRepository);

  Future<String> execute(String id) async {
    return kotaRepository.deleteKota(id);
  }
}
