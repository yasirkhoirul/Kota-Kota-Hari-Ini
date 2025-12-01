import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';
import 'package:kota_kota_hari_ini/persentation/pages/login_page.dart';
import 'package:kota_kota_hari_ini/persentation/provider/kota_notifier.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';
import 'package:kota_kota_hari_ini/persentation/widget/imagekota.dart';
import 'package:kota_kota_hari_ini/persentation/widget/page.dart';
import 'package:kota_kota_hari_ini/persentation/widget/slideintext.dart';
import 'package:kota_kota_hari_ini/persentation/widget/sliverheader.dart';
import 'package:provider/provider.dart';

class KotaPage extends StatelessWidget {
  const KotaPage({super.key});
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
            slivers: [
              SliverAppBar(
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
                          ? Positioned.fill(child: ContentBar())
                          : Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: ContentBar(),
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
                      hintText: "Cari Sesuatu?",
                      trailing: [Icon(Icons.search)],
                    ),
                  ),
                  maxheight: 200,
                  minheight: 150,
                ),
              ),
              lebar
                  ? SliverToBoxAdapter(
                      child: PageItem(
                        items: context.read<KotaNotifier>().datakota,
                      ),
                    )
                  : SliverList.builder(
                      itemCount: context.read<KotaNotifier>().datakota.length,
                      itemBuilder: (context, index) {
                        final data = context
                            .read<KotaNotifier>()
                            .datakota[index];
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            onTap: () => context.push('/detail', extra: data),
                            leading: Container(color: Colors.amber ,child: Heroes(data.id, imageUrl: data.imagePath[0])),
                            title: Text(data.namaKota,style: GoogleFonts.robotoFlex(
                              fontWeight: FontWeight.bold
                            ),),
                            subtitle: Text(data.deskripsiSingkat,maxLines: 3,overflow: TextOverflow.ellipsis,),
                          ),
                        );
                      },
                    ),
                SliverToBoxAdapter(
                  child: lebar?Container(): SizedBox(height: 30,),
                )
            ],
          ),
        );
      },
    );
  }
}

class ContentBar extends StatelessWidget {
  const ContentBar({super.key});
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
                Expanded(child: SearchContent(ismobile: false)),
              ],
            ),
          );
        } else {
          return Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SearchContent(ismobile: true),
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
  const SearchContent({super.key, required this.ismobile});

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
              BoxInput(
                lead: "CARI SESUATU",
                icon: Icon(Icons.search),
                obsecure: false,
                controller: control,
                validator: (value) => null,
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
