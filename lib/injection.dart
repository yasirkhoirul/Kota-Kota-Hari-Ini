import 'package:get_it/get_it.dart';
import 'package:kota_kota_hari_ini/data/data_remote_source.dart';
import 'package:kota_kota_hari_ini/data/kota_repository_impl.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_all_kota.dart';
import 'package:kota_kota_hari_ini/persentation/provider/kota_notifier.dart';

final GetIt getIt = GetIt.instance;

void init(){

  //repository
  getIt.registerLazySingleton<KotaRepository>(() => KotaRepositoryImpl(dataRemoteSource: getIt()),);

  //usecase
  getIt.registerLazySingleton(() => GetAllKota(repository: getIt()),);

  //dataremotsource
  getIt.registerLazySingleton<DataRemoteSource>(() => DataRemoteSourceImpl(),);

  //provider
  getIt.registerFactory(() => KotaNotifier(getAllKota: getIt()),);
}