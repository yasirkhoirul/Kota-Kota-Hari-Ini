import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';

abstract class KotaRepository {
  Future<List<KotaEntity>> getAllKota();
}