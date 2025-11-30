import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/domain/entity/kota_entity.dart';
import 'package:kota_kota_hari_ini/persentation/widget/frostglass.dart';
import 'package:kota_kota_hari_ini/persentation/widget/slideintext.dart';

class DetailPage extends StatefulWidget {
  final KotaEntity data;
  const DetailPage({super.key, required this.data});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool istinggi;
  late bool islebar;
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

        return DetailContent(
          istinggi: istinggi,
          islebar: islebar,
          data: widget.data,
        );
      },
    );
  }
}

class DetailContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: "kedetail${data.id}",
                child: CachedNetworkImage(
                  imageUrl: data.imagePath[0],
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Center(
              child: FrostedGlassScreen(
                width: islebar ? MediaQuery.of(context).size.width * 0.8 : 800,
                height: istinggi
                    ? MediaQuery.of(context).size.height * 0.8
                    : 1000,
                child: SlideInText(
                  child: istinggi && islebar
                      ? Row(
                          children: [
                            Expanded(child: Gambar(data: data)),
                            Expanded(child: ContentDetail(data: data)),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(child: Gambar(data: data)),
                            Expanded(child: ContentDetail(data: data)),
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
        child: Container(
          color: Colors.white,
          child: CachedNetworkImage(
            imageUrl: data.imagePath[0],
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
  const ContentDetail({super.key, required this.data});

  final KotaEntity data;

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
            Text(data.deskripsiPanjang,style: GoogleFonts.robotoFlex(
              color: Colors.white
            ),),
          ],
        ),
      ),
    );
  }
}
