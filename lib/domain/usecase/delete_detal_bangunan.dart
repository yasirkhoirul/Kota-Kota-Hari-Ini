import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class DeleteDetalBangunan {
  final KotaRepository kotaRepository;
  const DeleteDetalBangunan(this.kotaRepository);

  Future<String> execute(int idDetailBangunan,String imageUrl)async{
    return kotaRepository.deleteDetailBangunan(idDetailBangunan, imageUrl);
  }
}