import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class Tambahkota {
  final KotaRepository kotaRepository;
  const Tambahkota(this.kotaRepository);

  Future<String> execute(
    String namakota,
    String deskripsisingkat,
    String deskripsipanajng,
    String image_path,
    String created,
    String lokasi,
  ) async {
    return await kotaRepository.tambahdatakota(
      namakota,
      deskripsisingkat,
      deskripsipanajng,
      image_path,
      created,
      lokasi,
    );
  }
}
