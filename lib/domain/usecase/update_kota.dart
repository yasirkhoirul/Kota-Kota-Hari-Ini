import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class UpdateKota {
  final KotaRepository kotaRepository;
  const UpdateKota(this.kotaRepository);

  Future<String> execute(KotaEntity data) async {
    return kotaRepository.updateKota(data);
  }
}
