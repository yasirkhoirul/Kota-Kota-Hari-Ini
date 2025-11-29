import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';
import 'package:kota_kota_hari_ini/common/request_state.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/persentation/provider/kota_notifier.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:kota_kota_hari_ini/persentation/widget/slideintext.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final CarouselSliderController controllercarausel =
      CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withAlpha(250),
                Colors.black.withAlpha(40),
                Colors.black.withAlpha(0),
              ],
              begin: AlignmentGeometry.bottomCenter,
              end: AlignmentGeometry.topCenter,
            ),
          ),
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: -2,
          child: Image.asset(Images.siluetbackground, fit: BoxFit.fitWidth),
        ),
        Positioned(right: 0, child: SvgPicture.asset(Images.circleright)),
        Positioned(bottom: 0, child: SvgPicture.asset(Images.cricleback)),
        Content(controllercarausel: controllercarausel),
      ],
    );
  }
}

class Content extends StatefulWidget {
  final CarouselSliderController controllercarausel;
  const Content({super.key, required this.controllercarausel});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KotaNotifier>().getAllkota();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 45, child: ContentLeft()),
        Expanded(
          flex: 65,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Consumer<KotaNotifier>(
              builder: (context, value, chlid) {
                if (value.statuskota == RequestState.loaded) {
                  return Column(
                    spacing: 0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 5,
                        child: CarouselSlider(
                          carouselController: widget.controllercarausel,
                          items: value.datakota.asMap().entries.map((e) {
                            final int index = e.key;
                            return Builder(
                              builder: (context) {
                                return ItemCoarsel(index: index,e: e,);
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            onPageChanged: (index, reason) =>
                                value.setCorselindex(index),
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlayAnimationDuration: Duration(
                              milliseconds: 800,
                            ),
                            viewportFraction: 0.3,
                          ),
                        ),
                      ),
                      Flexible(
                        child: IndicatorCroasel(
                          widget: widget,
                          currentindex: value.indexcorsel,
                          count: value.datakota.length,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ItemCoarsel extends StatelessWidget {
  const ItemCoarsel({
    super.key,
    required this.index, required this.e,
  });
  final MapEntry<int, KotaEntity> e;
  final int index;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(
              e.value.imagePath[0],
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: InkWell(
          onTap: context.watch<KotaNotifier>().indexcorsel == index
              ? () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Membuka item $index",
                      ),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.end,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
            
              children: [
                Container(
                  color: Colors.white,
                  height: 2,
                  width:
                      (MediaQuery.of(
                        context,
                      ).size.width *
                      0.02),
                ),
            
                SizedBox(height: 5),
                Text(
                  e.value.lokasi,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
                Text(
                  "${e.value.namaKota} ",
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IndicatorCroasel extends StatelessWidget {
  const IndicatorCroasel({
    super.key,
    required this.widget,
    required this.count,
    required int currentindex,
  }) : _currentindex = currentindex;

  final Content widget;
  final int count;
  final int _currentindex;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            widget.controllercarausel.previousPage(
              duration: Duration(milliseconds: 300),
            );
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: Colors.white,
        ),
        AnimatedSmoothIndicator(
          activeIndex: _currentindex,
          count: count,
          effect: WormEffect(
            dotWidth: 5,
            dotHeight: 5,
            dotColor: Colors.white,
            activeDotColor: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            widget.controllercarausel.nextPage(
              duration: Duration(milliseconds: 300),
            );
          },
          icon: Icon(Icons.arrow_forward_ios_rounded),
          color: Colors.white,
        ),
      ],
    );
  }
}

class ContentLeft extends StatelessWidget {
  const ContentLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 5,
            width: 114,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          SlideInText(
            child: Text(
              "Selamat Datang",
              style: GoogleFonts.robotoFlex(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5),
          SlideInText(
            child: Text(
              textHeightBehavior: TextHeightBehavior(
                applyHeightToLastDescent: false,
                applyHeightToFirstAscent: false,
              ),
              "KOTA KOTA",
              style: GoogleFonts.robotoFlex(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 0,
                letterSpacing: -5,
              ),
            ),
          ),
          Text(
            textHeightBehavior: TextHeightBehavior(
              applyHeightToLastDescent: false,
              applyHeightToFirstAscent: false,
            ),
            "HARI INI",
            style: GoogleFonts.robotoFlex(
              fontSize: 96,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 0,
              letterSpacing: -5,
            ),
          ),
          SizedBox(height: 5),
          Text(
            """web edukasi tentang sejarah kota indonesia
intinya si webnya menjabarkan nilai historis dari kota kota di indonsia""",
            style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Lihat Kota Lain",
                    style: GoogleFonts.robotoFlex(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
