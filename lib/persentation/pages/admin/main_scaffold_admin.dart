import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_kota_hari_ini/persentation/widget/appbaradmin.dart';
import 'package:kota_kota_hari_ini/persentation/widget/drawercontent.dart';

class MainScaffoldAdmin extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final List<Widget> children;
  const MainScaffoldAdmin({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  @override
  State<MainScaffoldAdmin> createState() => _MainScaffoldAdminState();
}

class _MainScaffoldAdminState extends State<MainScaffoldAdmin> {
  final spasi = SizedBox(height: 10);
  void _gobranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width > 800
          ? null
          : Drawer(
              backgroundColor: Colors.black,
              child: DrawercontentAdmin(_gobranch),
            ),
      backgroundColor: Color(0xFF969393),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Builder(
          builder: (context) {
            return Appbaradmin(
              height: 200,
              ontaps: (index) {
                _gobranch(index);
              },
              drawetaps: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: widget.children[widget.navigationShell.currentIndex],
    );
  }
}
