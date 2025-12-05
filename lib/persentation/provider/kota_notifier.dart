import 'package:flutter/material.dart';
import 'package:kota_kota_hari_ini/common/request_state.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_all_kota.dart';

class KotaNotifier extends ChangeNotifier {
  int _indexcorsel = 0;
  int get indexcorsel => _indexcorsel;

  List<KotaEntity> _datakota = [];
  List<KotaEntity> get datakota => _datakota;

  RequestState _statuskota = RequestState.empty;
  RequestState get statuskota => _statuskota;

  String _message = "";
  String get message => _message;

  KotaNotifier({required this.getAllKota});
  final GetAllKota getAllKota;

  void setCorselindex(int index) {
    _indexcorsel = index;
    notifyListeners();
  }

  void getAllkota() async {
    _statuskota = RequestState.loding;
    notifyListeners();
    try {
      _datakota = await getAllKota.execute();
      _statuskota = RequestState.loaded;
    } catch (e) {
      _message = e.toString();
      _statuskota = RequestState.error;
    } finally {
      notifyListeners();
    }
  }
}
