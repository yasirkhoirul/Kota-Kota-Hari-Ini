import 'package:bloc/bloc.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/update_kota.dart';
import 'package:meta/meta.dart';

part 'update_kota_state.dart';

class UpdateKotaCubit extends Cubit<UpdateKotaState> {
  final UpdateKota updateKota;
  UpdateKotaCubit(this.updateKota) : super(UpdateKotaInitial());

  void onUpdate(KotaEntity data) async {
    emit(UpdateKotaLoading());
    try {
      final response = await updateKota.execute(data);
      emit(UpdateKotaLoaded(response));
    } catch (e) {
      emit(UpdateKotaError(e.toString()));
    }
  }
}
