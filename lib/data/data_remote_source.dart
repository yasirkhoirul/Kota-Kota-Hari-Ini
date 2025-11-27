import 'package:kota_kota_hari_ini/data/model/kotamodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DataRemoteSource {
  Future<List<Kotamodel>> getAllKota();
}

class DataRemoteSourceImpl implements DataRemoteSource {
  
  @override
  Future<List<Kotamodel>> getAllKota() async {
    try {
      final response = await Supabase.instance.client.from("Kota").select();
      final data = response.map((e) => Kotamodel.fromJson(e)).toList();
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
