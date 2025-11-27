import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kota_kota_hari_ini/data/database/supabase.dart';
import 'package:kota_kota_hari_ini/persentation/pages/main_scaffold_page.dart';
import 'package:kota_kota_hari_ini/persentation/provider/kota_notifier.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'injection.dart' as getit;

final GetIt getisinstance = GetIt.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: SupabaseUrl.datapiurl, anonKey: SupabaseUrl.apikeys);
  getit.init(); 
  runApp(

    MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => KotaNotifier(getAllKota: getisinstance()),)
    ],child: const MainApp(),)
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScaffoldPage()
    );
  }
}
