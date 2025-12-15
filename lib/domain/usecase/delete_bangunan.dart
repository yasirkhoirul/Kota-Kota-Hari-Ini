import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class DeleteBangunan {
  final KotaRepository kotaRepository;
  const DeleteBangunan(this.kotaRepository);

  Future<String> execute(int idBangunan, String imageUrl)async{
    return kotaRepository.deleteBangunan(idBangunan, imageUrl);
  }
}