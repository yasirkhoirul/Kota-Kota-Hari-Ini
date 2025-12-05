import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class GetSearchKota {
  final KotaRepository repository;
  const GetSearchKota(this.repository);

  Future<List<KotaEntity>> execute(String query) {
    return repository.searchKota(query);
  }
}
