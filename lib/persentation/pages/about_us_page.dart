import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/common/constant.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(Images.siluetbackground)),
        Positioned.fill(child: Container(color: Colors.white)),
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
                      if (contrains.maxWidth > 759 && contrains.maxHeight>640) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: ItemCard()),
                            Expanded(child: ItemCard()),
                            Expanded(child: ItemCard()),
                          ],
                        );
                      } else {
                        return ListView.builder(itemCount: 3,itemBuilder: (context, index) {
                          if (index == 0) {
                            return ItemCard();
                          }
                          if (index == 1) {
                            return ItemCard();
                          }
                          if (index == 2) {
                            return ItemCard();
                          }
                        },);
                      }
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
  const ItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: SizedBox(
        width: 300,
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Judul",
              style: GoogleFonts.robotoFlex(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Deskripsi",
              style: GoogleFonts.robotoFlex(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
