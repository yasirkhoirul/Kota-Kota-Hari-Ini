import 'package:bloc/bloc.dart';
import 'package:kota_kota_hari_ini/domain/entity/bangunan_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_bangunan_kota.dart';
import 'package:meta/meta.dart';

part 'bangunan_kota_state.dart';

class BangunanKotaCubit extends Cubit<BangunanKotaState> {
  final GetBangunanKota getBangunanKota;
  BangunanKotaCubit(this.getBangunanKota) : super(BangunanKotaInitial());

  void getBangunan(String idkota)async{
    emit(BangunanKotaLoading());
    try {
      final data = await getBangunanKota.execute(idkota);
      emit(BangunanKotaLoaded(data));
    } catch (e) {
      emit(BangunanKotaError(e.toString()));
    }
  }
}
