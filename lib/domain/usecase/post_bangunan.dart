import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class AddBangunanUseCase {
  final KotaRepository repository;

  AddBangunanUseCase(this.repository);

  Future<void> execute(XFile image, int idKota, String deskripsi) {
    return repository.addBangunan(image, idKota, deskripsi);
  }
}