import 'dart:io';
import 'dart:typed_data';
import 'package:gotrue/src/types/session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/data/data_remote_source.dart';
import 'package:kota_kota_hari_ini/data/model/kotamodel.dart';
import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';
import 'package:kota_kota_hari_ini/domain/entity/detail_bangunan_entity.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';

class KotaRepositoryImpl implements KotaRepository {
  KotaRepositoryImpl({required this.dataRemoteSource});
  final DataRemoteSource dataRemoteSource;
  @override
  Future<List<KotaEntity>> getAllKota() async {
    try {
      final data = await dataRemoteSource.getAllKota();
      return data.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<KotaEntity>> searchKota(String keyword) async {
    try {
      final data = await dataRemoteSource.searchKota(keyword);
      return data.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadKota(Uint8List img, String path) async {
    try {
      final data = await dataRemoteSource.uploadKota(img, path);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> uploadStorageFoto(Uint8List? file, String? mimeType) async {
    try {
      final data = await dataRemoteSource.uploadStorageFoto(file, mimeType);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> tambahdatakota(
    String namakota,
    String deskripsisingkat,
    String deskripsipanajng,
    String image_path,
    String created,
    String lokasi,
  ) async {
    try {
      final data = await dataRemoteSource.tambahDataKota(
        namakota,
        deskripsisingkat,
        deskripsipanajng,
        image_path,
        created,
        lokasi,
      );
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Session> login(String ur, String pw) async {
    try {
      final data = await dataRemoteSource.login(pw, ur);
      if (data != null) {
        return data;
      } else {
        throw Exception("session kosong");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  @override
  Future<bool> ceklogin() async {
    try {
      final data = await dataRemoteSource.statuslogin();
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> logout() async {
    try {
      final data = await dataRemoteSource.signout();
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<KotaEntity> getOneKota(String id) async {
    try {
      final data = await dataRemoteSource.getOneKota(id);
      return data.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateKota(KotaEntity data) async {
    try {
      final readydata = Kotamodel.fromEntity(data);
      final response = await dataRemoteSource.updatedataKota(readydata);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deletePhoto(int rowId, String urlToDelete) async {
    try {
      await dataRemoteSource.deleteImage(rowId, urlToDelete);
      await dataRemoteSource.deleteImagefromBucket(rowId, urlToDelete);
      return "sukses";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteKota(String id) async {
    try {
      final response = await dataRemoteSource.deleteKota(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BangunanEntity>> getBangunan(String idkota) async{
    try {
      final data = await dataRemoteSource.getBangunanKota(idkota);
      return data.map((e) => e.toEntity(e),).toList();
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<List<DetailBangunanEntity>> getBangunanDetail(int idkota) async{
    try {
      final data = await dataRemoteSource.getDetailBangunan(idkota);
      return data.map((e) => e.toEntity(),).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addBangunan(XFile image, int idKota, String deskripsi) async{
    try {
      // 1. Jalankan Upload Image
      final String imageUrl = await dataRemoteSource.uploadImage(image);

      // 2. Gunakan URL hasil upload untuk Insert ke DB
      await dataRemoteSource.insertBangunan(
        idKota: idKota,
        imageUrl: imageUrl,
        deskripsi: deskripsi,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> addDetailBangunan(XFile image, int idBangunan, String deskripsi) async{
    final url = await dataRemoteSource.uploadDetailImage(image);
    // 2. Simpan data
    await dataRemoteSource.insertDetailBangunan(
      idBangunan: idBangunan,
      imagePath: url,
      deskripsi: deskripsi,
    );
  }
}
