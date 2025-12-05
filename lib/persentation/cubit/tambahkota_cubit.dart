import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/domain/usecase/tambahkota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/uploadfotostorage.dart';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';
part 'tambahkota_state.dart';

class TambahkotaCubit extends Cubit<TambahkotaState> {
  final ImagePicker imagePicker;
  final Uploadfotostorage uploadfotostorage;
  final Tambahkota tambahkota;
  TambahkotaCubit(
    this.uploadfotostorage,
    this.tambahkota, {
    required this.imagePicker,
  }) : super(TambahkotaInitial());

  Future<void> pickImage() async {
    try {
      // Pilih dari Galeri (Ganti ImageSource.camera jika ingin dari kamera)
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Kompresi sedikit agar file tidak terlalu besar
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        final mimeType = lookupMimeType(pickedFile.path) ?? "image/jpeg";
        emit(TambahKotaPickGambar(mimeType, bytes));
      }
    } catch (e) {
      emit(TambahkotaError(message: "Gagal mengambil gambar: $e"));
    }
  }

  void tambahkotaform(
    Uint8List file,
    String namakota,
    String path,
    String deskripsisingkat,
    String deskripsipanajng,
    String created,
    String lokasi,
  ) async {
    emit(TambahkotaLoading());
    try {
      final urlimage = await uploadfotostorage.execute(file, path);
      emit(TambahkotaLoadingUpGambar());
      final response = await tambahkota.execute(
        namakota,
        deskripsisingkat,
        deskripsipanajng,
        urlimage,
        created,
        lokasi,
      );
      emit(TambahkotaLOaded(message: response));
    } catch (e) {
      emit(TambahkotaError(message: e.toString()));
    }
  }
}
