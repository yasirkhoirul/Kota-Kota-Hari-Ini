import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/delete_bangunan.dart';
import 'package:kota_kota_hari_ini/domain/usecase/post_bangunan.dart';
import 'package:meta/meta.dart';

part 'add_bangunan_state.dart';

class AddBangunanCubit extends Cubit<AddBangunanState> {
  final AddBangunanUseCase addBangunanUseCase;
  final DeleteBangunan deleteBangunan;
  AddBangunanCubit(this.addBangunanUseCase, {required this.deleteBangunan}) : super(AddBangunanInitial());


  void onsubmit(String  deskripsi,XFile image,int idkota)async{
    emit(AddBangunanLoading());
      try {
        await addBangunanUseCase.execute(image, idkota, deskripsi);
        emit(AddBangunanSuccess());
      } catch (e) {
        emit(AddBangunanError(e.toString()));
      }
  }
  Future<void> deleteBangunanKota(int idbangunan, String imageUrl)async{

    emit(AddBangunanLoading());
    try {
      final response = await deleteBangunan.execute(idbangunan, imageUrl);
      emit(AddBangunanSuccessDelete());
    } catch (e) {
      emit(AddBangunanError(e.toString()));
    }
  }
}
