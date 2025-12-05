import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota_kota_hari_ini/data/data_remote_source.dart';
import 'package:kota_kota_hari_ini/data/kota_repository_impl.dart';
import 'package:kota_kota_hari_ini/domain/repository/kota_repository.dart';
import 'package:kota_kota_hari_ini/domain/usecase/delete_image_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/delete_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_all_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_one_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_search_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/get_status_login.dart';
import 'package:kota_kota_hari_ini/domain/usecase/login.dart';
import 'package:kota_kota_hari_ini/domain/usecase/logout.dart';
import 'package:kota_kota_hari_ini/domain/usecase/post_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/tambahkota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/update_kota.dart';
import 'package:kota_kota_hari_ini/domain/usecase/uploadfotostorage.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/auth_user_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/delete_image_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/delete_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_kota_dart_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/loader_asset_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/search_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/tambahkota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/update_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/upload_page_dart_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/provider/kota_notifier.dart';

final GetIt getIt = GetIt.instance;

void init() {
  //image instance
  getIt.registerLazySingleton<ImagePicker>(() => ImagePicker());

  //repository
  getIt.registerLazySingleton<KotaRepository>(
    () => KotaRepositoryImpl(dataRemoteSource: getIt()),
  );

  //usecase
  getIt.registerLazySingleton(() => GetAllKota(repository: getIt()));
  getIt.registerLazySingleton(() => GetSearchKota(getIt()));
  getIt.registerLazySingleton(() => PostKota(kotaRepository: getIt()));
  getIt.registerLazySingleton(() => Uploadfotostorage(getIt()));
  getIt.registerLazySingleton(() => Tambahkota(getIt()));
  getIt.registerLazySingleton(() => Login(getIt()));
  getIt.registerLazySingleton(() => GetStatusLogin(getIt()));
  getIt.registerLazySingleton(() => Logout(getIt()));
  getIt.registerLazySingleton(() => GetOneKota(getIt()));
  getIt.registerLazySingleton(() => UpdateKota(getIt()));
  getIt.registerLazySingleton(() => DeleteImageKota(getIt()));
  getIt.registerLazySingleton(() => DeleteKota(getIt()));

  //dataremotsource
  getIt.registerLazySingleton<DataRemoteSource>(() => DataRemoteSourceImpl());

  //provider
  getIt.registerFactory(() => KotaNotifier(getAllKota: getIt()));
  getIt.registerFactory(() => LoaderAssetCubit());
  getIt.registerFactory(() => SearchKotaCubit(getIt(), getAllKota: getIt()));
  getIt.registerFactory(() => UploadPageDartCubit(getIt(), kota: getIt()));
  getIt.registerFactory(
    () => TambahkotaCubit(getIt(), getIt(), imagePicker: getIt()),
  );
  getIt.registerFactory(
    () => AuthUserCubit(getIt(), getStatusLogin: getIt(), logout: getIt()),
  );
  getIt.registerFactory(() => DetailKotaDartCubit(getIt()));
  getIt.registerFactory(() => UpdateKotaCubit(getIt()));
  getIt.registerFactory(() => DeleteImageCubit(getIt()));
  getIt.registerFactory(() => DeleteKotaCubit(getIt()));
}
