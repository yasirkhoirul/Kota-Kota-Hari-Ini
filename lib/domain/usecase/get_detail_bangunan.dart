import 'package:kota_kota_hari_ini/domain/entity/detail_bangunan_entity.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class GetDetailBangunan {
  final KotaRepository kotaRepository;
  const GetDetailBangunan(this.kotaRepository);
  Future<List<DetailBangunanEntity>> execute(int idbangunan) async {
    return kotaRepository.getBangunanDetail(idbangunan);
  }
}