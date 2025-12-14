import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/auth_user_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/notifier/listenauth.dart';
import 'package:kota_kota_hari_ini/persentation/pages/about_us_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/admin/input_detail_bangunan_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/admin/inputbangunan_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/contact_us_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/detail_bangunan.dart';
import 'package:kota_kota_hari_ini/persentation/pages/detail_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/detail_page_custom.dart';
import 'package:kota_kota_hari_ini/persentation/pages/admin/edit_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/fullscreenpage.dart';
import 'package:kota_kota_hari_ini/persentation/pages/home_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/admin/kota_admin_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/kota_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/login_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/admin/main_scaffold_admin.dart';
import 'package:kota_kota_hari_ini/persentation/pages/main_scaffold_page.dart';
import 'package:kota_kota_hari_ini/persentation/pages/admin/tambahkota_page.dart';
import 'package:kota_kota_hari_ini/persentation/widget/dialog.dart';
import 'package:logger/web.dart';

class Approute {
  // Inisialisasi Listener
  static GoRouter myRouter(AuthUserCubit authCubitInstance) {
    final rootNavigatorKey = GlobalKey<NavigatorState>();
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      refreshListenable: CubitListenable(authCubitInstance),
      routes: <RouteBase>[
        GoRoute(
          path: '/detail/:iddetail',
          name: 'detail',
          builder: (context, state) {
            final id = state.pathParameters['iddetail'];
            return DetailPageCustom(id: id ?? '');
          },
          routes: [
            GoRoute(
              path: '/fullscreen/:url/:tag',
              name: 'fullscreen',
              builder: (context, state) {
                final imageUrl = state.pathParameters['url'];
                final tag = state.pathParameters['tag'];
                return FullscreenImagePage(
                  imageUrl: imageUrl ?? '',
                  tag: tag ?? '',
                );
              },
            ),
            GoRoute(
              path: '/DetailBangunan/:idbangunan/:image',
              name: 'detailbangunan',
              builder: (context, state) {
                final idbangunan = state.pathParameters['idbangunan'];
                int idBangunanReady = 0;
                if (idbangunan != null) {
                  idBangunanReady = int.parse(idbangunan);
                }
                final image = state.pathParameters['image'];
                return DetailBangunan(
                  idBangunan: idBangunanReady,
                  imageBangunan: image ?? '',
                );
              },
            ),
          ],
        ),

        GoRoute(
          path: '/update',
          builder: (context, state) {
            final data = state.extra as KotaEntity;
            return MyDialog(kotaEntity: data);
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
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/KotaAdmin",
                  builder: (context, state) => KotaAdminPage(),
                  routes: [
                    GoRoute(
                      path: "Bangunan/:id",
                      name: 'bangunan',
                      builder: (context, state) {
                        final data = state.pathParameters['id'];
                        return BangunanKotaPage(idKota: data ?? '');
                      },
                      routes: [
                        GoRoute(path: "detailbangunankota/:idbangunan",name: 'detailbangunankota',builder: (context, state) {
                          final data = state.pathParameters['idbangunan'];
                          int id = 0;
                          if (data!=null) {
                            id = int.parse(data);
                          }
                          return DetailBangunanPage(idBangunan: id,namaBangunan:  "detailbangunan");
                        },)
                        
                      ]
                    ),
                    GoRoute(
                      path: "Edit/:id",
                      name: 'edit',
                      builder: (context, state) {
                        final datas = state.pathParameters['id'];
                        return EditPage(id: datas ?? '');
                      },
                      routes: [
                        GoRoute(
                          path: 'editpage/:childId',
                          name: 'editpage',
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            final childId = state.pathParameters['childId']!;
                            return CustomTransitionPage(
                              child: MyDialogUpPhoto(id: int.parse(childId)),
                              opaque: false,
                              barrierColor: Colors.black54,
                              barrierDismissible: false,
                              transitionsBuilder:
                                  (context, animation, secondary, child) =>
                                      FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
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
                  path: "/contact",
                  builder: (context, state) => ContactUsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: "/about",
                  builder: (context, state) => AboutUsPage(),
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
        const List adminPath = [
          '/upload',
          '/KotaAdmin',
          '/Edit/:id',
          '/update',
          '/editpage/:id',
        ];
        const String loginPath = '/login';
        Logger().d("redirect  $isLogin");
        // Rute Publik (yang seharusnya tidak diakses admin)
        final bool isPublicPath = [
          '/home',
          loginPath,
          '/kota',
          '/about',
          '/contact',
        ].contains(location);

        if (isLogin) {
          // Jika SUDAH LOGIN, cek apakah dia sedang mencoba mengakses rute publik/login.
          if (isPublicPath) {
            // Jika ya, paksa redirect ke halaman admin default.
            return '/upload';
          }
          // Jika tidak di rute publik/login (misalnya sudah di /upload atau /detail), biarkan.
          return null;
        } else {
          // Jika BELUM LOGIN, cek apakah dia mencoba mengakses rute yang dilindungi (/upload).
          final bool isProtectedRoute = adminPath.contains(location);

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
