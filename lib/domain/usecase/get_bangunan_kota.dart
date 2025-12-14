import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class GetBangunanKota {
  final KotaRepository kotaRepository;
  const GetBangunanKota(this.kotaRepository);

  Future<List<BangunanEntity>> execute(String idkoa)async{
    return kotaRepository.getBangunan(idkoa);
  }
}