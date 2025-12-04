import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/search_kota_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/pages/login_page.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';
import 'package:kota_kota_hari_ini/persentation/widget/imagekota.dart';
import 'package:kota_kota_hari_ini/persentation/widget/page.dart';
import 'package:kota_kota_hari_ini/persentation/widget/slideintext.dart';
import 'package:kota_kota_hari_ini/persentation/widget/sliverheader.dart';
import 'package:logger/logger.dart';

class KotaPage extends StatefulWidget {
  const KotaPage({super.key});

  @override
  State<KotaPage> createState() => _KotaPageState();
}

class _KotaPageState extends State<KotaPage> {
  final ScrollController _controllerscroll = ScrollController();
  double _lastscroll = 0;
  @override
  void initState() {
    context.read<SearchKotaCubit>().init();
    _controllerscroll.addListener(() {
      _lastscroll = _controllerscroll.offset;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerscroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool tinggi;
    bool lebar;
    return LayoutBuilder(
      builder: (context, constrian) {
        if (constrian.maxWidth > 900) {
          lebar = true;
        } else {
          lebar = false;
        }
        if (constrian.maxHeight > 800) {
          tinggi = true;
        } else {
          tinggi = false;
        }
        return Container(
          color: Colors.white,
          child: CustomScrollView(
            controller: _controllerscroll,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: tinggi ? constrian.maxHeight : 1000,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          Images.kotaappbar,
                          fit: BoxFit.cover,
                        ),
                      ),
                      tinggi
                          ? Positioned.fill(
                              child: ContentBar(onSubmitted: (String p1) {

                                context.read<SearchKotaCubit>().onSearch(p1);
                                _controllerscroll.animateTo(_controllerscroll.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeInOutCubic);
                              }),
                            )
                          : Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: ContentBar(onSubmitted: (String p1) {
                                context.read<SearchKotaCubit>().onSearch(p1);
                                _controllerscroll.animateTo(_controllerscroll.position.maxScrollExtent, duration: Duration(milliseconds: 1), curve: Curves.easeInOutCubic);
                              }),
                            ),
                    ],
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Scroll ke bawah",
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: tinggi && lebar ? 36 : 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "untuk menjelajah kota kota",
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: tinggi && lebar ? 20 : 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                              size: tinggi && lebar ? 100 : 50,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("$index"),
                  );
                },
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: Sliverheader(
                  child: Center(
                    child: SearchBar(
                      onSubmitted: (value) {
                        context.read<SearchKotaCubit>().onSearch(value);
                      },
                      hintText: "Cari Sesuatu?",
                      trailing: [Icon(Icons.search)],
                    ),
                  ),
                  maxheight: 100,
                  minheight: 80,
                ),
              ),
              lebar
                  ? SliverToBoxAdapter(
                      child: BlocBuilder<SearchKotaCubit, SearchKotaState>(
                        builder: (context, state) {
                          if (state is SearchKotaLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is SearchKotaLoaded) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _controllerscroll.animateTo(
                                _lastscroll,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
                            });

                            
                            return state.data.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Text("Tidak Ada Kota Ditemukan"),
                                    ),
                                  )
                                : PageItem(items: state.data);
                          } else {
                            return Center(child: Text("terjadi kesalahan"));
                          }
                        },
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: BlocBuilder<SearchKotaCubit, SearchKotaState>(
                        builder: (context, state) {
                          
                          if (state is SearchKotaLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is SearchKotaLoaded) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _controllerscroll.animateTo(
                                _lastscroll,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOutCubic,
                              );
                            });
                            Logger().d(state.data);
                            return state.data.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Text("Tidak Ada Kota Ditemukan"),
                                    ),
                                  )
                                : SizedBox(
                                    height: 500,
                                    child: ListView.builder(
                                      itemCount: state.data.length,
                                      itemBuilder: (context, index) => Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          onTap: () => context.push(
                                            '/detail',
                                            extra: state.data[index],
                                          ),
                                          leading: SizedBox(
                                            height: 56
                                            ,
                                            width: 56,
                                            child: state.data[index].imagePath.isEmpty?Container(): 
                                            Heroes(
                                              state.data[index].id!,
                                              imageUrl: state
                                                  .data[index]
                                                  .imagePath.first,
                                            ),
                                          ),
                                          title: Text(
                                            state.data[index].namaKota,
                                            style: GoogleFonts.robotoFlex(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            state.data[index].deskripsiSingkat,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          } else {
                            return Center(child: Text("terjadi kesalahan"));
                          }
                        },
                      ),
                    ),
              SliverToBoxAdapter(
                child: lebar ? Container() : SizedBox(height: 30),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ContentBar extends StatelessWidget {
  final Function(String) onSubmitted;
  const ContentBar({super.key, required this.onSubmitted});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return Padding(
            padding: const EdgeInsets.all(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: TextContent(ismobile: false)),
                Expanded(
                  child: SearchContent(
                    ismobile: false,
                    onSubmitted: onSubmitted,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SearchContent(ismobile: true, onSubmitted: onSubmitted),
              ),
              TextContent(ismobile: true),
            ],
          );
        }
      },
    );
  }
}

class SearchContent extends StatefulWidget {
  final bool ismobile;
  final Function(String) onSubmitted;
  const SearchContent({
    super.key,
    required this.ismobile,
    required this.onSubmitted,
  });

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  final TextEditingController control = TextEditingController();
  @override
  void dispose() {
    control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FrostedGlassScreen(
      width: MediaQuery.of(context).size.width * 0.8,
      height: widget.ismobile ? 200 : 300,
      child: SlideInText(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "JELAJAHI KOTA",
                  style: GoogleFonts.robotoFlex(
                    fontSize: widget.ismobile ? 32 : 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Form(
                child: BoxInput(
                  textInputAction: TextInputAction.done,
                  onSubmitted: widget.onSubmitted,
                  lead: "CARI SESUATU",
                  icon: Icon(Icons.search),
                  obsecure: false,
                  controller: control,
                  validator: (value) => null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextContent extends StatelessWidget {
  const TextContent({super.key, required this.ismobile});
  final bool ismobile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: ismobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideInText(
            child: Text(
              textHeightBehavior: TextHeightBehavior(
                applyHeightToLastDescent: false,
                applyHeightToFirstAscent: false,
              ),
              "KOTA",
              style: GoogleFonts.robotoFlex(
                fontSize: ismobile ? 45 : 96,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                height: 0,
                letterSpacing: -5,
              ),
            ),
          ),
          SlideInText(
            child: Text(
              textHeightBehavior: TextHeightBehavior(
                applyHeightToLastDescent: false,
                applyHeightToFirstAscent: false,
              ),
              "DI DUNIA",
              style: GoogleFonts.robotoFlex(
                fontSize: ismobile ? 45 : 96,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 0,
                letterSpacing: -5,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 5,
            width: 114,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 50),
          SlideInText(
            child: Text(
              "pada halamans ini anda akan dibawa ke berbagai macam macam kota \nmulai dari sabang sampai merauke",
              style: GoogleFonts.robotoFlex(
                color: Colors.white,
                fontSize: ismobile ? 11 : 16,
                fontWeight: FontWeight.w100,
              ),
              textAlign: ismobile ? TextAlign.center : TextAlign.left,
            ),
          ),
          SizedBox(height: 50),
          SlideInText(
            child: Row(
              mainAxisAlignment: ismobile
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              spacing: 20,
              children: [
                Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: ismobile ? 25 : 50,
                ),
                Icon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                  size: ismobile ? 25 : 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
