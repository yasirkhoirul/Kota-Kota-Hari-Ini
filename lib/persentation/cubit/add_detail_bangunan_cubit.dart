import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/domain/usecase/delete_detal_bangunan.dart';
import 'package:kota_kota_hari_ini/domain/usecase/post_detail_bangunan.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';

part 'add_detail_bangunan_state.dart';

class AddDetailBangunanCubit extends Cubit<AddDetailBangunanState> {
  final AddDetailUseCase addDetailBangunanCubit;
  final DeleteDetalBangunan deleteDetalBangunan;
  AddDetailBangunanCubit(this.addDetailBangunanCubit, {required this.deleteDetalBangunan}) : super(AddDetailInitial());

  Future<void> addDetail({
    required XFile image,
    required int idBangunan,
    required String deskripsi,
  }) async {
    emit(AddDetailLoading());
    try {
      await addDetailBangunanCubit.execute(image, idBangunan, deskripsi);
      emit(AddDetailSuccess());
    } catch (e) {
      emit(AddDetailError(e.toString()));
    }
  }

  Future<void> deleteDetail(int idDetailBangunan, String imageUrl)async{
    Logger().d(idDetailBangunan);
    emit(AddDetailLoading());
    try {
      final response = await deleteDetalBangunan.execute(idDetailBangunan, imageUrl);
      emit(AddDeleteSuccess());
    } catch (e) {
      emit(AddDetailError(e.toString()));
    }
  }
}
