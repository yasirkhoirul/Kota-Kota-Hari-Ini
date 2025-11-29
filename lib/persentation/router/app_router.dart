import 'package:go_router/go_router.dart';
import 'package:kota_kota_hari_ini/persentation/pages/home_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/login_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/main_scaffold_page.dart';
class Approute {
   static final GoRouter routermain = GoRouter(
    routes: <RouteBase>[
      StatefulShellRoute(
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (context, state) => HomePage(),),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/kota', builder: (context, state) => LoginPage(),),
            ],
          ),
        ],
        navigatorContainerBuilder: (context, navigationShell, child) =>
            MainScaffoldPage(navigationShell: navigationShell,children: child,),
      ),
    ],
    initialLocation: '/home',
  );
}
