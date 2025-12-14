import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';
import 'package:kota_kota_hari_ini/domain/entity/detail_bangunan_entity.dart';
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
  Future<String> updateKota(KotaEntity data);

  Future<String> deletePhoto(int rowId, String urlToDelete);
  Future<String> deleteKota(String id);
  Future<List<BangunanEntity>> getBangunan(String idkota); 
  Future<List<DetailBangunanEntity>> getBangunanDetail(int idbangunan);
  Future<void> addBangunan(XFile image, int idKota, String deskripsi);
  Future<void> addDetailBangunan(XFile image, int idBangunan, String deskripsi);
}
