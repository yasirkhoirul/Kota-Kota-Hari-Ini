import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/persentation/cubit/detail_kota_dart_cubit.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';
import 'package:kota_kota_hari_ini/persentation/widget/slideintext.dart';

class DetailPage extends StatefulWidget {
  final KotaEntity? data;
  final String id;
  const DetailPage({super.key, required this.data, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool istinggi;
  late bool islebar;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DetailKotaDartCubit>().onGetKota(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > 600) {
          istinggi = true;
        } else {
          istinggi = false;
        }
        if (constraints.maxWidth > 1400) {
          islebar = true;
        } else {
          islebar = false;
        }

        return widget.data == null
            ? BlocBuilder<DetailKotaDartCubit, DetailKotaDartState>(
                builder: (context, state) {
                  if (state is DetailKotaDartLoaded) {
                    return DetailContent(
                      istinggi: istinggi,
                      islebar: islebar,
                      data: state.data,
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            : DetailContent(
                istinggi: istinggi,
                islebar: islebar,
                data: widget.data!,
              );
      },
    );
  }
}

class DetailContent extends StatefulWidget {
  final KotaEntity data;
  final bool istinggi;
  final bool islebar;
  const DetailContent({
    super.key,
    required this.istinggi,
    required this.islebar,
    required this.data,
  });

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  bool isgalerry = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: "kedetail${widget.data.id}",
                child: CachedNetworkImage(
                  imageUrl: widget.data.imagePath.isEmpty
                      ? ""
                      : widget.data.imagePath[0],
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Center(
              child: isgalerry
                  ? FrostedGlassScreen(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: widget.istinggi
                          ? MediaQuery.of(context).size.height * 0.8
                          : 1000,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: widget.data.imagePath.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              final id = widget.data.id;
                              context.goNamed(
                                'fullscreen',
                                pathParameters: {
                                  'url': widget.data.imagePath[index],
                                  'tag': 'image$index',
                                  'iddetail': id.toString(),
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(15),
                              child: Hero(
                                tag: 'image$index',
                                child: CachedNetworkImage(
                                  imageUrl: widget.data.imagePath[index],
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),

                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : FrostedGlassScreen(
                      width: widget.islebar
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width * 0.9,
                      height: widget.istinggi
                          ? MediaQuery.of(context).size.height * 0.8
                          : 1000,
                      child: SlideInText(
                        child: widget.istinggi && widget.islebar
                            ? Row(
                                children: [
                                  Expanded(child: Gambar(data: widget.data)),
                                  Expanded(
                                    child: ContentDetail(
                                      data: widget.data,
                                      onPressed: () {
                                        setState(() {
                                          isgalerry = !isgalerry;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(child: Gambar(data: widget.data)),
                                  Expanded(
                                    child: ContentDetail(
                                      data: widget.data,
                                      onPressed: () {
                                        setState(() {
                                          isgalerry = !isgalerry;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gambar extends StatelessWidget {
  const Gambar({super.key, required this.data});

  final KotaEntity data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(15),
          child: CachedNetworkImage(
            imageUrl: data.imagePath.isEmpty ? "" : data.imagePath[0],
            errorWidget: (context, url, error) => Icon(Icons.error),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ContentDetail extends StatelessWidget {
  const ContentDetail({super.key, required this.data, required this.onPressed});

  final KotaEntity data;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.namaKota,
              style: GoogleFonts.robotoFlex(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFFB7410E)),
                Text(
                  data.lokasi,
                  style: GoogleFonts.robotoFlex(
                    color: Color(0xFFB7410E),
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Divider(
                height: 30,
                radius: BorderRadius.circular(10),
                thickness: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              data.deskripsiPanjang,
              style: GoogleFonts.robotoFlex(color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: onPressed,
              child: Text(
                "Galeri",
                style: GoogleFonts.robotoFlex(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
