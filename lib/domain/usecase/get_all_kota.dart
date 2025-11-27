import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class GetAllKota {
  final KotaRepository repository;
  GetAllKota({required this.repository});
  
  Future<List<KotaEntity>> execute()async{
    return repository.getAllKota();
  }
}