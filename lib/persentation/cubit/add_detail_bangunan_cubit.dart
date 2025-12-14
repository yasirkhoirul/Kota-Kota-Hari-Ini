import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/domain/usecase/post_detail_bangunan.dart';
import 'package:meta/meta.dart';

part 'add_detail_bangunan_state.dart';

class AddDetailBangunanCubit extends Cubit<AddDetailBangunanState> {
  final AddDetailUseCase addDetailBangunanCubit;
  AddDetailBangunanCubit(this.addDetailBangunanCubit) : super(AddDetailInitial());

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
}
