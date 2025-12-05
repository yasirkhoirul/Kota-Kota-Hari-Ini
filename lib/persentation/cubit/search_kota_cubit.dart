import 'package:bloc/bloc.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_all_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_search_kota.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'search_kota_state.dart';

class SearchKotaCubit extends Cubit<SearchKotaState> {
  final GetSearchKota getSearchKota;
  final GetAllKota getAllKota;
  SearchKotaCubit(this.getSearchKota, {required this.getAllKota})
    : super(SearchKotaInitial());

  void onSearch(String query) async {
    emit(SearchKotaLoading());
    try {
      final response = await getSearchKota.execute(query);
      emit(SearchKotaLoaded(response));
    } catch (e) {
      emit(SearchKotaError(e.toString()));
    }
  }

  void init() async {
    Logger().d("masuk init");
    emit(SearchKotaLoading());
    try {
      final response = await getAllKota.execute();
      emit(SearchKotaLoaded(response));
    } catch (e) {
      emit(SearchKotaError(e.toString()));
    }
  }
}
