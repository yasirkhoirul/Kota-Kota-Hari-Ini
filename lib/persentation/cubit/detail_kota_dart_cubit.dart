import 'package:bloc/bloc.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_one_kota.dart';
import 'package:meta/meta.dart';

part 'detail_kota_dart_state.dart';

class DetailKotaDartCubit extends Cubit<DetailKotaDartState> {
  final GetOneKota getOneKota;
  DetailKotaDartCubit(this.getOneKota) : super(DetailKotaDartInitial());

  void onGetKota(String id)async{
   emit(DetailKotaDartLoading());
    try {
      final data = await getOneKota.execute(id);
      emit(DetailKotaDartLoaded(data));
    } catch (e) {
      emit(DetailKotaDartError(e.toString()));
    }
  }
}
