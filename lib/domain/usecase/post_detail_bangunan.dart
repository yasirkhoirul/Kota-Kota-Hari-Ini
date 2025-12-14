import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class AddDetailUseCase {
  final KotaRepository repository;
  AddDetailUseCase(this.repository);

  Future<void> execute(XFile image, int idBangunan, String deskripsi) {
    return repository.addDetailBangunan(image, idBangunan, deskripsi);
  }
}