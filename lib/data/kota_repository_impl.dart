import 'package:kota_kota_hari_ini/data/data_remote_source.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class KotaRepositoryImpl implements KotaRepository{

  KotaRepositoryImpl({required this.dataRemoteSource});
  final DataRemoteSource dataRemoteSource;
  @override
  Future<List<KotaEntity>> getAllKota() async{
    try {
      final data = await dataRemoteSource.getAllKota();
      return data.map((e) => e.toEntity(),).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}