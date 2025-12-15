import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/data/model/bangunanmode.dart';
import 'package:kota_kota_hari_ini/data/model/detailbangunanmodel.dart';
import 'package:kota_kota_hari_ini/data/model/kotamodel.dart';
import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';
import 'package:logger/web.dart';
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
  Future<String> deleteKota(String id);
  Future<List<Bangunanmode>> getBangunanKota(String idKota);

  Future<List<DetailBangunanModel>> getDetailBangunan(int idBangunan);
  Future<String> uploadImage(XFile imageFile);
  Future<void> insertBangunan({required int idKota, required String imageUrl, required String deskripsi});
  Future<String> uploadDetailImage(XFile image); // Upload khusus detail
  Future<void> insertDetailBangunan({
    required int idBangunan, 
    required String imagePath, 
    required String deskripsi
  });
  Future<bool> deleteDetailBangunan(int id, String imageUrl);
  Future<bool> deleteBangunan(int id, String imageUrl);
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
      await Supabase.instance.client
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
    final String columnName =
        'image_path'; // Nama kolom array// Nama bucket storage

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
        await Supabase.instance.client.storage.from(bucketName).remove([
          filePath,
        ]);
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

  @override
  Future<String> deleteKota(String id) async {
    try {
      final supabase = Supabase.instance.client;
      final data = await supabase.from("Kota").select().eq("id", id);
      if (data.isEmpty) {
        throw Exception("tidak ada data");
      } else {
        final dataimage = Kotamodel.fromJson(data.first);
        if (dataimage.image_path.isNotEmpty) {
          throw Exception("Image Harus Dihapus Semua");
        } else {
          final data = await supabase.from("Kota").delete().eq("id", id);
          return "Sukses menghapus ${dataimage.nama_kota} $data ";
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<List<Bangunanmode>> getBangunanKota(String idKota) async{
    final supabase = Supabase.instance.client;
    Logger().d("Id kota $idKota");
    try {
      final response = await supabase
          .from('BangunanaKota')
          .select()
          .eq('id_kota', idKota);

      final data = response as List<dynamic>;
      Logger().d("Data yang ada $response");
      return data.map((item) => Bangunanmode.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<DetailBangunanModel>> getDetailBangunan(int idBangunan) async {
    final supabase = Supabase.instance.client;
    
    try {
      final response = await supabase
          .from('DetailBangunan') // Sesuaikan huruf besar/kecil nama tabel
          .select()
          .eq('id_bangunan', idBangunan); // PENTING: Ganti 'id_bangunan' dengan nama kolom FK di tabel DetailBangunan anda

      // Cek jika kosong (opsional, untuk debugging)
      if (response.isEmpty) {
        Logger().w("Detail bangunan kosong untuk ID: $idBangunan");
        return [];
      }

      final data = response as List<dynamic>;
      return data.map((item) => DetailBangunanModel.fromJson(item)).toList();
      
    } catch (e) {
      Logger().e("Error getDetailBangunan: $e");
      throw Exception("Gagal mengambil detail: $e");
    }
  }
  
  @override
  Future<void> insertBangunan({required int idKota, required String imageUrl, required String deskripsi}) async{
    final supabase = Supabase.instance.client;
    try {
      // Sesuai screenshot tabel: 'BangunanaKota'
      await supabase.from('BangunanaKota').insert({
        'id_kota': idKota,
        'image_path': imageUrl,
        'deskipsi': deskripsi, // Sesuai typo di DB
      });
    } catch (e) {
      throw Exception("Gagal Insert Database: $e");
    }
  }
  
  @override
  Future<String> uploadImage(XFile imageFile) async{
    final supabase = Supabase.instance.client;
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = 'bangunan_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      // Sesuai screenshot bucket anda: 'Galeri', folder: 'bangunan'
      final path = 'bangunan/$fileName';

      await supabase.storage.from('Galeri').updateBinary(
            path,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Ambil Public URL
      final String publicUrl = supabase.storage.from('Galeri').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception("Gagal Upload Gambar: $e");
    }
  }
  
  @override
  Future<void> insertDetailBangunan({required int idBangunan, required String imagePath, required String deskripsi}) async{
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('DetailBangunan').insert({
        'id_bangunan': idBangunan, // Foreign Key
        'images_path': imagePath,  // Sesuai nama kolom di DB
        'deskripsi': deskripsi,
      });
    } catch (e) {
      throw Exception("Gagal Insert Detail: $e");
    }
  }
  
  @override
  Future<String> uploadDetailImage(XFile image) async{
   final supabase = Supabase.instance.client;
   try {
      final bytes = await image.readAsBytes();
      final fileExt = image.name.split('.').last;
      final fileName = 'detail_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      
      // PENTING: Arahkan ke folder 'detailBangunan' sesuai screenshot
      final path = 'detailBangunan/$fileName'; 

      await supabase.storage.from('Galeri').uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Ambil Public URL
      return supabase.storage.from('Galeri').getPublicUrl(path);
    } catch (e) {
      throw Exception("Gagal Upload Detail: $e");
    }
  }
  
  @override
  Future<bool> deleteDetailBangunan(int id, String imageUrl) async{
    final supabase = Supabase.instance.client;
   try {
    
    // 1. Tentukan Nama Bucket sesuai gambar kamu
    const String bucketName = 'Galeri';

    // 2. Ambil "Path File" dari URL
    // URL Asli: https://xyz.supabase.co/.../public/Galeri/detailBangunan/foto.jpg
    // Kita butuh string setelah 'Galeri/' -> yaitu "detailBangunan/foto.jpg"
    
    // Logic: Split URL berdasarkan nama bucket
    final String path = imageUrl.split('/$bucketName/').last; 

    // 3. Hapus File dari Bucket 'Galeri'
    // .remove() meminta list path file (contoh: ['detailBangunan/foto.jpg'])
    await supabase.storage.from(bucketName).remove([path]);

    // 4. Hapus Data Row di Database (Tabel 'detail_bangunan')
    await supabase.from('DetailBangunan').delete().eq('id', id);
    return  true;
  } catch (e) {
    Logger().e(e.toString());
    return false;
  }
  }
  
  @override
  Future<bool> deleteBangunan(int id, String imageUrl)async{
    final supabase = Supabase.instance.client;
   try {
    
    // 1. Tentukan Nama Bucket sesuai gambar kamu
    const String bucketName = 'Galeri';

    // 2. Ambil "Path File" dari URL
    // URL Asli: https://xyz.supabase.co/.../public/Galeri/detailBangunan/foto.jpg
    // Kita butuh string setelah 'Galeri/' -> yaitu "detailBangunan/foto.jpg"
    
    // Logic: Split URL berdasarkan nama bucket
    final String path = imageUrl.split('/$bucketName/').last; 

    // 3. Hapus File dari Bucket 'Galeri'
    // .remove() meminta list path file (contoh: ['detailBangunan/foto.jpg'])
    await supabase.storage.from(bucketName).remove([path]);

    // 4. Hapus Data Row di Database (Tabel 'detail_bangunan')
    await supabase.from('BangunanaKota').delete().eq('id', id);
    return  true;
  } catch (e) {
    Logger().e(e.toString());
    return false;
  }
  }
}
