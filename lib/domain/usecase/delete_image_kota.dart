import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class DeleteImageKota {
  final KotaRepository kotaRepository;
  const DeleteImageKota(this.kotaRepository);

  Future<String> execute(int rowId, String urlToDelete) {
    return kotaRepository.deletePhoto(rowId, urlToDelete);
  }
}
