import 'dart:typed_data';

import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class KotaRepository {
  Future<List<KotaEntity>> getAllKota();
  Future<List<KotaEntity>> searchKota(String query);
  Future<Session> login(String ur, String pw);
  Future<String> logout();
  Future<bool> ceklogin();
  Future<String> uploadKota(Uint8List img, String path);
  Future<String> uploadStorageFoto(Uint8List img, String path);
  Future<KotaEntity> getOneKota(String id);
  Future<String> tambahdatakota(
    String namakota,
    String deskripsisingkat,
    String deskripsipanajng,
    String image_path,
    String created,
    String lokasi,
  );
  Future<String> updateKota(
    KotaEntity data
  );

  Future<String> deletePhoto(
   int rowId, String urlToDelete
  );
  Future<String> deleteKota(String id);
}
