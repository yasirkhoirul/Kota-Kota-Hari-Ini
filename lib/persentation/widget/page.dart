import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';
import 'package:kota_kota_hari_ini/persentation/widget/imagekota.dart';

class PageItem extends StatefulWidget {
  final List<KotaEntity> items;
  const PageItem({super.key, required this.items});

  @override
  State<PageItem> createState() => _PageItemState();
}

class _PageItemState extends State<PageItem> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  int get itemsPerPage => 4;
  int get pageCount => (widget.items.length / itemsPerPage).ceil();

  List<KotaEntity> getItemsByPage(int pageIndex) {
    final startIndex = pageIndex * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage < widget.items.length)
        ? startIndex + itemsPerPage
        : widget.items.length;
    return widget.items.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 187, 184, 184),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            bottom: -2,
            child: Image.asset(Images.siluetbackground, fit: BoxFit.fitWidth),
          ),
          Column(
            children: [
              SizedBox(
                height: 800,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100,right: 100,left: 100),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pageCount,
                    onPageChanged: (index) {
                      setState(() => currentPage = index);
                    },
                    itemBuilder: (context, pageIndex) {
                      final pageItems = getItemsByPage(pageIndex);
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          print(constraints.maxWidth);
                          double width = constraints.maxWidth;
                          double height = constraints.maxHeight;

                          // Hitung aspect ratio berdasarkan ukuran area yang tersedia
                          double itemWidth = width / 2; // 2 kolom
                          double itemHeight = height / 2; // 2 baris
                          double aspectRatio = itemWidth / itemHeight;
                          return GridView.builder(
                            physics:
                                NeverScrollableScrollPhysics(), // Scroll via PageView
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: aspectRatio,
                                ),
                            itemCount: pageItems.length,
                            itemBuilder: (context, i) {
                              return AnimationConfiguration.staggeredGrid(
                                position: i,
                                columnCount: 2,
                                duration: const Duration(milliseconds: 600),
                                child: FadeInAnimation(
                                  curve: Curves.easeIn,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: FrostedGlassScreen(
                                      height: double.maxFinite,
                                      width: double.maxFinite,
                                      child: ItemPage(data: pageItems[i]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // PAGE INDICATOR
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 900),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: Center(child: Icon(Icons.arrow_back,color: Colors.white,)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: IconButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 900),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: Icon(Icons.arrow_forward,color: Colors.white,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemPage extends StatelessWidget {
  final KotaEntity data;
  const ItemPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/detail', extra: data),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.namaKota,
                    style: GoogleFonts.robotoFlex(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data.lokasi,
                    style: GoogleFonts.robotoFlex(
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Text(
                    data.deskripsiSingkat,
                    maxLines: 3,
                    style: GoogleFonts.robotoFlex(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                child: Container(
                  color: Colors.white,
                  height: double.maxFinite,
                  width: 50,
                  child: Heroes(data.id, imageUrl: data.imagePath[0])
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
