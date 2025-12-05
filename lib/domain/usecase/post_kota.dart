import 'dart:typed_data';

import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class PostKota {
  final KotaRepository kotaRepository;
  const PostKota({required this.kotaRepository});

  Future<String> execute(Uint8List img, String id) {
    return kotaRepository.uploadKota(img, id);
  }
}
