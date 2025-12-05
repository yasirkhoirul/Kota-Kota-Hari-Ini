import 'package:bloc/bloc.dart';
import 'package:kota_kota_hari_ini/domain/usecase/delete_kota.dart';
import 'package:meta/meta.dart';

part 'delete_kota_state.dart';

class DeleteKotaCubit extends Cubit<DeleteKotaState> {
  final DeleteKota deleteKota;
  DeleteKotaCubit(this.deleteKota) : super(DeleteKotaInitial());

  void onDelet(String id)async{
    emit(DeleteKotaLoading());
    try {
      final data = await deleteKota.execute(id);
      emit(DeleteKotaLoaded(data));
    } catch (e) {
      emit(DeleteKotaError(e.toString()));
    }
  }
}
