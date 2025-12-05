import 'package:bloc/bloc.dart';
import 'package:kota_kota_hari_ini/domain/usecase/delete_image_kota.dart';
import 'package:meta/meta.dart';

part 'delete_image_state.dart';

class DeleteImageCubit extends Cubit<DeleteImageState> {
  final DeleteImageKota deleteImageKota;
  DeleteImageCubit(this.deleteImageKota) : super(DeleteImageInitial());

  void ondelete(int rowId, String urlToDelete) async {
    emit(DeleteImageLoading());
    try {
      await deleteImageKota.execute(rowId, urlToDelete);
      emit(DeleteImageLoaded("berhasil di hapus"));
    } catch (e) {
      emit(DeleteImageError(e.toString()));
    }
  }
}
