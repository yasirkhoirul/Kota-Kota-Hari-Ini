import 'dart:typed_data';

import 'package:kota_kota_hari_ini/data/model/kotamodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DataRemoteSource {
  Future<List<Kotamodel>> getAllKota();
  Future<List<Kotamodel>> searchKota(String keyword);
  Future<Kotamodel> getOneKota(String id);
  Future<String> signout();
  Future<Session?> login(String ur, String email);
  Future<bool> statuslogin();
  Future<String> uploadKota(Uint8List imagefile, String rowid);
  Future<String> uploadStorageFoto(Uint8List? file, String? mimeType);
  Future<String> tambahDataKota(
    String namakota,
    String deskripsisingkat,
    String deskripsipanajng,
    String image_path,
    String created,
    String lokasi,
  );
  Future<String> updatedataKota(Kotamodel data);
  Future<String> deleteImage(int rowId, String urltoDelete);
  Future<void> deleteImagefromBucket(int rowId, String urlToDelete);
  String getPathFromUrl(String fullUrl, String bucketName);
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
  Future<String> tambahDataKota(
    String namakota,
    String deskripsisingkat,
    String deskripsipanajng,
    String image_path,
    String created,
    String lokasi,
  ) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('Kota').insert({
        'nama_kota': namakota,
        'deskripsi_singkat': deskripsisingkat,
        'deskripsi_panjang': deskripsipanajng,
        'image_path': [image_path],
        'lokasi': lokasi,
      });
      return "succes";
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> signout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      return "berhasil logout";
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Kotamodel> getOneKota(String id) async {
    try {
      final data = await Supabase.instance.client
          .from("Kota")
          .select()
          .eq("id", id)
          .single();
      return Kotamodel.fromJson(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> updatedataKota(Kotamodel data) async {
    try {
      final update = await Supabase.instance.client
          .from('Kota')
          .update({
            'nama_kota': data.nama_kota,
            'deskripsi_singkat': data.deskripsi_singkat,
            'deskripsi_panjang': data.deskripsi_panjang,
            'image_path': data.image_path,
            'lokasi': data.lokasi,
          })
          .eq('id', data.id);

      return "Berhasil update";
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<String> deleteImage(int rowId, String urlToDelete) async {
    final supabase = Supabase.instance.client;

    // GANTI 3 VARIABEL INI SESUAI PROYEK ANDA:
    final String tableName = 'Kota'; // Nama tabel
    final String columnName = 'image_path'; // Nama kolom array// Nama bucket storage

    try {
      // ---------------------------------------------
      // TAHAP A: UPDATE DATABASE (Hapus URL dari Array)
      // ---------------------------------------------

      // 1. Ambil data array saat ini
      final data = await supabase
          .from(tableName)
          .select(columnName)
          .eq('id', rowId)
          .single();

      List<dynamic> currentUrls = List.from(data[columnName] ?? []);
      List<dynamic> newUrls = currentUrls
          .where((url) => url != urlToDelete)
          .toList();
      await supabase
          .from(tableName)
          .update({columnName: newUrls})
          .eq('id', rowId);

      ///
      return "sukses delete di tabel";
      //
    } catch (e) {
      throw Exception(e);
      // Tampilkan snackbar error disini jika perlu
    }
  }

  @override
  Future<void> deleteImagefromBucket(int rowId, String urlToDelete) async {
    final String bucketName = 'Galeri';
    try {
      // 1. Helper function tadi otomatis akan mendeteksi folder 'uploads'
      // Hasil filePath nanti akan menjadi: "uploads/1764752418337.jpg"
      String filePath = getPathFromUrl(urlToDelete, bucketName);

      if (filePath.isNotEmpty) {
        // Supabase akan menghapus file di dalam folder uploads bucket Galeri
        await Supabase.instance.client.storage.from(bucketName).remove([filePath]);
        print("✅ File berhasil dihapus dari folder uploads: $filePath");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  String getPathFromUrl(String fullUrl, String bucketName) {
    try {
      Uri uri = Uri.parse(fullUrl);
      // Contoh path URL: /storage/v1/object/public/Galeri/uploads/foto.jpg

      // Kita ambil bagian path-nya saja dan pecah menjadi list
      List<String> segments = uri.pathSegments;

      // Cari posisi nama bucket ('Galeri') di dalam URL
      int bucketIndex = segments.indexOf(bucketName);

      // Jika nama bucket ketemu, ambil semua bagian SETELAH bucket
      if (bucketIndex != -1 && bucketIndex + 1 < segments.length) {
        // Menggabungkan kembali menjadi: "uploads/foto.jpg"
        return segments.sublist(bucketIndex + 1).join('/');
      }

      return '';
    } catch (e) {
      return '';
    }
  }
}
