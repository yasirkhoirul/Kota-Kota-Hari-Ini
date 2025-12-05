import 'package:flutter/foundation.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class Uploadfotostorage {
  final KotaRepository kotaRepository;
  const Uploadfotostorage(this.kotaRepository);

  Future<String> execute(Uint8List file, String path) {
    return kotaRepository.uploadStorageFoto(file, path);
  }
}
