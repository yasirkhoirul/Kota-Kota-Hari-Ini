import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';
import 'package:kota_kota_hari_ini/persentation/widget/slideintext.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(Images.siluetbackground)),
        Positioned.fill(child: Container(color: Colors.black.withAlpha(125))),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "About Us",
                  style: GoogleFonts.robotoFlex(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, contrains) {
                      return ItemCard(icon: Images.iconAboutkiri, judul: "Sejarah Hidup dalam Kota", deskripsi: """Kota-Kota Hari Ini adalah sebuah platform kajian sejarah kota yang mengulas bangunan-bangunan bersejarah di Indonesia yang kembali aktif dan digunakan dalam kehidupan masa kini, baik dengan fungsi yang sama seperti tujuan awal pembentukannya maupun dengan fungsi baru yang beradaptasi dengan kebutuhan zaman. Berdasarkan data Kementerian Kebudayaan, hingga saat ini terdapat sekitar 542 bangunan bersejarah yang masih berdiri di Indonesia, tersebar di berbagai kota dengan konteks sosial, budaya, dan lingkungan yang beragam. Website ini hadir untuk membaca kembali bangunan-bangunan tersebut sebagai bagian dari dinamika kota yang terus berubah, bukan sebagai artefak beku masa lalu.

Pendekatan yang digunakan dalam website ini merujuk pada konsep Historic Urban Landscape (HUL), sebuah pendekatan komprehensif yang diperkenalkan dan dipromosikan oleh UNESCO untuk pengelolaan kota bersejarah. HUL memandang kota sebagai lanskap yang berlapis, mencakup bangunan bersejarah, lingkungan alam, ruang publik, pola tata ruang, praktik sosial, nilai budaya, serta kehidupan masyarakat yang terus berkembang. Dengan demikian, pelestarian tidak hanya berfokus pada perlindungan fisik bangunan, tetapi juga pada keberlanjutan fungsi sosial, budaya, dan ekonomi kawasan bersejarah.

Dalam konteks kajian sejarah kota, HUL menjadi kerangka penting untuk memahami bagaimana warisan masa lalu berinteraksi dengan kebutuhan masa kini. Bangunan bersejarah yang kini berfungsi sebagai ruang pertunjukan, restoran, museum, kantor, atau ruang publik menunjukkan bahwa sejarah dapat tetap hidup dan relevan tanpa kehilangan nilai dan identitasnya. Sejalan dengan prinsip HUL, Kota-Kota Hari Ini menempatkan masyarakat sebagai aktor utama, serta memandang perubahan sebagai bagian tak terpisahkan dari sejarah kota itu sendiri.

Melalui kajian, dokumentasi, dan narasi visual, website ini berupaya mendorong pemahaman bahwa bangunan bersejarah bukan sekadar objek pelestarian, melainkan ruang hidup yang membentuk identitas kota hari ini dan masa depan.

Penyusun :
Bambang Rakhmanto, M. Hum.
Dr. Nina Witasari, S.S., M.Hum.
Deftian Isya Mahendra
Nailatul Asna""");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final String icon;
  final String judul;
  final String deskripsi;
  const ItemCard({super.key, required this.icon, required this.judul, required this.deskripsi});

  @override
  Widget build(BuildContext context) {
    return SlideInText(
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.all(20),
        child: SizedBox(
          width: 800,
      
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    judul,
                    style: GoogleFonts.robotoFlex(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: SvgPicture.asset(icon,fit: BoxFit.fitWidth,),),
                  Text(
                    textAlign: TextAlign.center,
                    deskripsi,
                    style: GoogleFonts.robotoFlex(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
