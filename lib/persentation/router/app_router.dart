import 'package:go_router/go_router.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/persentation/pages/contact_us_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/detail_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/home_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/kota_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/login_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/main_scaffold_page.dart';

class Approute {
  static final GoRouter routermain = GoRouter(
    routes: <RouteBase>[
       GoRoute(
        path: '/detail',
        builder: (context, state) {
          final data = state.extra as KotaEntity;
          return DetailPage(data: data);
        },
      ),
      StatefulShellRoute(
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (context, state) => HomePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/login', builder: (context, state) => LoginPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/kota', builder: (context, state) => KotaPage()),
            ],
          ),
          StatefulShellBranch(routes: 
            [
              GoRoute(path: "/about",builder: (context, state) => ContactUsPage(),)
            ]
          )
        ],
        
        navigatorContainerBuilder: (context, navigationShell, children) {
          return MainScaffoldPage(
            navigationShell: navigationShell,
            children: children, 
          );
        },
        builder: (context, state, navigationShell) {
          return navigationShell;
        },
      ),
    ],
    initialLocation: '/home',
  );
}
