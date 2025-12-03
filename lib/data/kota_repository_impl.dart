import 'dart:io';
import 'dart:typed_data';
import 'package:gotrue/src/types/session.dart';
import 'package:kota_kota_hari_ini/data/data_remote_source.dart';
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
      }else{
        throw Exception("session kosong");
      }
    } catch (e) {
      throw Exception("$e");
    } 
  }
  
  @override
  Future<bool> ceklogin() async{
    try {
      final data = await dataRemoteSource.statuslogin();
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<String> logout() async{
    try {
      final data = await dataRemoteSource.signout();
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
