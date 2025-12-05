import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/domain/usecase/post_kota.dart';
import 'package:meta/meta.dart';

part 'upload_page_dart_state.dart';

class UploadPageDartCubit extends Cubit<UploadPageDartState> {
  final ImagePicker imagePicker;
  final PostKota kota;
  UploadPageDartCubit(this.imagePicker, {required this.kota}) : super(UploadPageDartInitial());

  Future<void> pickImage() async {
    try {
      // Pilih dari Galeri (Ganti ImageSource.camera jika ingin dari kamera)
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, 
        imageQuality: 80, // Kompresi sedikit agar file tidak terlalu besar
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        emit(UploadPageDartLoaded(fileName: pickedFile.name,mimeType: pickedFile.mimeType,imageBytes: bytes));
      }
    } catch (e) {
      emit(UploadPageDartError("Gagal mengambil gambar: $e"));
    }
  }

  void goinit(){
    emit(UploadPageDartInitial());
  }

  Future<void> uploadForm(String id) async{
    if (state is UploadPageDartLoaded) {
    final currentState = state as UploadPageDartLoaded; // gambar sudah ada disini
    try {
      if (currentState.imageBytes != null) {
        final data = await kota.execute(currentState.imageBytes!, id); // contoh upload ke usecase
        emit(UploadPageDartSuccess(data));
      }
    } catch (e) {
      emit(UploadPageDartError("Gagal upload: $e"));
    }
  } else {
    emit(UploadPageDartError("Tidak ada gambar yang dipilih"));
  }
  }

}
