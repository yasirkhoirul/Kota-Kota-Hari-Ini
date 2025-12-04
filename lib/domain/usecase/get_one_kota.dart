import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class GetOneKota {
  final KotaRepository kotaRepository;
  const GetOneKota(this.kotaRepository);

  Future<KotaEntity> execute(String id){
    return kotaRepository.getOneKota(id);
  }
}