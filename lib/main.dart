import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kota_kota_hari_ini/data/database/supabase.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/add_bangunan_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/add_detail_bangunan_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/auth_user_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/bangunan_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/delete_image_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/delete_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_bangunan_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_kota_dart_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/loader_asset_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/search_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/tambahkota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/update_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/upload_page_dart_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/provider/kota_notifier.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kota_kota_hari_ini/persentation/router/app_router.dart';
import 'injection.dart' as getit;

final GetIt getisinstance = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseUrl.datapiurl,
    anonKey: SupabaseUrl.apikeys,
  );
  getit.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => KotaNotifier(getAllKota: getisinstance()),
        ),
        BlocProvider(create: (context) => getisinstance<LoaderAssetCubit>()),
        BlocProvider(create: (context) => getisinstance<SearchKotaCubit>()),
        BlocProvider(create: (context) => getisinstance<UploadPageDartCubit>()),
        BlocProvider(create: (context) => getisinstance<TambahkotaCubit>()),
        BlocProvider(create: (context) => getisinstance<DetailKotaDartCubit>()),
        BlocProvider(create: (context) => getisinstance<UpdateKotaCubit>()),
        BlocProvider(create: (context) => getisinstance<DeleteImageCubit>()),
        BlocProvider(create: (context) => getisinstance<DeleteKotaCubit>()),
        BlocProvider(create: (context) => getisinstance<BangunanKotaCubit>()),
        BlocProvider(create: (context) => getisinstance<DetailBangunanCubit>()),
        BlocProvider(create: (context) => getisinstance<AddBangunanCubit>()),
        BlocProvider(create: (context) => getisinstance<AddDetailBangunanCubit>()),
        BlocProvider(
          create: (context) => getisinstance<AuthUserCubit>()..getstatuslogin(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Kota kota hari ini",
      routerConfig: Approute.myRouter(context.read<AuthUserCubit>()),
    );
  }
}
