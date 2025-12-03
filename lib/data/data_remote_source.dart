import 'dart:typed_data';

import 'package:kota_kota_hari_ini/data/model/kotamodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DataRemoteSource {
  Future<List<Kotamodel>> getAllKota();
  Future<List<Kotamodel>> searchKota(String keyword);
  Future<String> signout();
  Future<Session?> login(String ur, String email);
  Future<bool> statuslogin();
  Future<String> uploadKota(Uint8List imagefile, String rowid);
  Future<String> uploadStorageFoto(Uint8List? file, String? mimeType);
  Future<String> tambahDataKota(String namakota, String deskripsisingkat, String deskripsipanajng, String image_path, String created, String lokasi);
}

class DataRemoteSourceImpl implements DataRemoteSource {
  @override
  Future<List<Kotamodel>> getAllKota() async {
    try {
      final response = await Supabase.instance.client.from("Kota").select();
      final data = response.map((e) => Kotamodel.fromJson(e)).toList();
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Kotamodel>> searchKota(String keyword) async {
    try {
      final response = await Supabase.instance.client
          .from('Kota')
          .select()
          .ilike('nama_kota', '%$keyword%'); // case-insensitive search
      return response.map((e) => Kotamodel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Session?> login(String pw, String email) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        password: pw,
        email: email,
      );
      if (response.user != null) {
        return response.session;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> statuslogin() async {
    return Supabase.instance.client.auth.currentUser != null;
  }

  @override
  Future<String> uploadKota(Uint8List? file, String rowid) async {
    try {
      final instance = Supabase.instance.client;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'uploads/$fileName';

      await instance.storage
          .from("Galeri")
          .uploadBinary(
            path,
            file!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = instance.storage
          .from('Galeri')
          .getPublicUrl(path);
      print('Foto berhasil diupload: $publicUrl');
      await instance.rpc(
        'append_photo_url',
        params: {
          'row_id': int.parse(rowid), // Sesuai nama parameter di SQL
          'new_url': publicUrl, // Sesuai nama parameter di SQL
        },
      );

      return 'Database berhasil diupdate via RPC!';
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> uploadStorageFoto(Uint8List? file, String? mimeType) async {
    try {
      final supabase = Supabase.instance.client;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'uploads/$fileName';

      await supabase.storage
          .from('Galeri')
          .uploadBinary(
            path,
            file!,
            fileOptions: FileOptions(contentType: mimeType, upsert: false),
          );

      // Ambil Public URL
      final String publicUrl = supabase.storage
          .from('Galeri')
          .getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> tambahDataKota(String namakota, String deskripsisingkat, String deskripsipanajng, String image_path, String created, String lokasi) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('Kota').insert(
        {
          'nama_kota': namakota,
          'deskripsi_singkat': deskripsisingkat,
          'deskripsi_panjang': deskripsipanajng,
          'image_path': [image_path],
          'lokasi': lokasi,
        },
      );
      return "succes";
    } catch (e) {
      print("Error tambah data: $e");
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<String> signout() async{
    try {
      await Supabase.instance.client.auth.signOut();
      return "berhasil logout";
    } catch (e) {
      throw Exception(
        e
      );
    }
    
  }
}
