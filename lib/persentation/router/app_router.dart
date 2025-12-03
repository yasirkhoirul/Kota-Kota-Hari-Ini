import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/auth_user_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/notifier/listenauth.dart';
import 'package:kota_kota_hari_ini/persentation/pages/contact_us_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/detail_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/home_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/kota_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/login_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/main_scaffold_admin.dart';
import 'package:kota_kota_hari_ini/persentation/pages/main_scaffold_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/tambahkota_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/upload_page.dart';
import 'package:logger/web.dart';

class Approute {
  // Inisialisasi Listener
  static GoRouter myRouter(AuthUserCubit authCubitInstance) {
    return GoRouter(
      refreshListenable: CubitListenable(authCubitInstance),
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
                GoRoute(
                  path: "/upload",
                  builder: (context, state) => TambahkotaPage(),
                ),
              ],
            ),
          ],
          navigatorContainerBuilder: (context, navigationShell, children) =>
              MainScaffoldAdmin(
                navigationShell: navigationShell,
                children: children,
              ),
          builder: (context, state, navigationShell) {
            return navigationShell;
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
                GoRoute(
                  path: '/login',
                  builder: (context, state) => LoginPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(path: '/kota', builder: (context, state) => KotaPage()),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/about",
                  builder: (context, state) => ContactUsPage(),
                ),
              ],
            ),
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
        redirect: (context, GoRouterState stateredirect) {
          final state = authCubitInstance.state;
          final String location = stateredirect.matchedLocation;
          Logger().d(state);
          bool isLogin = state is AuthUserLoaded ? state.islogin : false;
          const String adminPath = '/upload';
          const String loginPath = '/login';
          Logger().d("redirect  $isLogin");
          // Rute Publik (yang seharusnya tidak diakses admin)
          final bool isPublicPath = [
            '/home',
            loginPath,
            '/kota',
            '/about',
          ].contains(location);

          if (isLogin) {
            // Jika SUDAH LOGIN, cek apakah dia sedang mencoba mengakses rute publik/login.
            if (isPublicPath) {
              // Jika ya, paksa redirect ke halaman admin default.
              return adminPath;
            }
            // Jika tidak di rute publik/login (misalnya sudah di /upload atau /detail), biarkan.
            return null;
          } else {
            // Jika BELUM LOGIN, cek apakah dia mencoba mengakses rute yang dilindungi (/upload).
            final bool isProtectedRoute = location == adminPath;

            if (isProtectedRoute) {
              // Jika ya, paksa redirect ke halaman login.
              return loginPath;
            }
          }

          // Tidak ada redirect yang diperlukan.
          return null;
        },
    );
  }
}
