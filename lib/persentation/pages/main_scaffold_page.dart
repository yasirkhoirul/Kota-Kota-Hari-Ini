import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/loader_asset_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/pages/splash_page.dart';
import 'package:kota_kota_hari_ini/persentation/widget/appbar.dart';
import 'package:kota_kota_hari_ini/persentation/widget/drawercontent.dart';
import 'package:kota_kota_hari_ini/persentation/widget/smartslideswitcher.dart';

class MainScaffoldPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
final List<Widget> children;
  const MainScaffoldPage({super.key, required this.navigationShell, required this.children});

  @override
  State<MainScaffoldPage> createState() => _MainScaffoldPageState();
}

class _MainScaffoldPageState extends State<MainScaffoldPage> {
  final spasi = SizedBox(height: 10,);
  void _gobranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<LoaderAssetCubit>().onloaded(context);
    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoaderAssetCubit, LoaderAssetState>(
       
      builder: (context, state) {
        if (state is LoaderAssetLoading) {
          return MySplashScreen();
        } else if (state is LoaderAssetError) {
          return Center(child: Text(state.message));
        } else if (state is LoaderAssetLoaded) {
          return Scaffold(
            drawer: MediaQuery.of(context).size.width>800?null:
            Drawer(
              backgroundColor: Colors.black,
              child: Drawercontent(_gobranch)
            ),
            backgroundColor: Color(0xFF969393),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Builder(
                builder: (context) {
                  return Appbars(
                    height: 200,
                    ontaps: (index) {
                      _gobranch(index);
                    }, drawetaps: () { 
                      Scaffold.of(context).openDrawer();
                     },
                  );
                }
              ),
            ),
            body: SmartSlideSwitcher(
              currentIndex:
                  widget.navigationShell.currentIndex, // Kirim index saat ini
              child: widget.children[widget.navigationShell.currentIndex], // Kirim kontennya
            ),
          );
        }else{
          return MySplashScreen();
        }
      },
    );
  }
}
