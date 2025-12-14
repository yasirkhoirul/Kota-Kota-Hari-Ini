import 'package:bloc/bloc.dart';
import 'package:kota_kota_hari_ini/domain/entity/detail_bangunan_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_detail_bangunan.dart';
import 'package:meta/meta.dart';

part 'detail_bangunan_state.dart';

class DetailBangunanCubit extends Cubit<DetailBangunanState> {
  final GetDetailBangunan getDetailBangunan;
  DetailBangunanCubit(this.getDetailBangunan) : super(DetailBangunanInitial());

  void getBangunan(int idkota)async{
    emit(DetailBangunanLoading());
    try {
      final data = await getDetailBangunan.execute(idkota);
      emit(DetailBangunanLoaded(data));
    } catch (e) {
      emit(DetailBangunanError(e.toString()));
    }
  }
}
