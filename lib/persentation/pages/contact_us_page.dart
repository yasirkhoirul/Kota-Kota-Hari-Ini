import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kota_kota_hari_ini/persentation/widget/slideintext.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        if (constrains.maxHeight > 650) {
          return ContactBack();
        } else {
          return SingleChildScrollView(
            child: SizedBox(height: 650, child: ContactBack()),
          );
        }
      },
    );
  }
}

class ContactBack extends StatelessWidget {
  const ContactBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withAlpha(51),
                  Colors.black.withAlpha(256),
                ],
                begin: AlignmentGeometry.bottomCenter,
                end: AlignmentGeometry.topCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          right: 0,
          left: 0,
          child: Image.asset("assets/image/kotlam.png", fit: BoxFit.fitWidth),
        ),
        ContentContactUs(),
      ],
    );
  }
}

class ContentContactUs extends StatelessWidget {
  const ContentContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideInText(
      child: LayoutBuilder(
        builder: (context, constrains) {
          final bool iswidth = constrains.maxWidth > 750;
          return Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFF969693),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Contact",
                    style: GoogleFonts.robotoFlex(
                      color: Color(0xFFB7410E),
                      fontSize: iswidth ? 32 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Us",
                    style: GoogleFonts.robotoFlex(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: iswidth ? 32 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                "ASK HOW",
                style: GoogleFonts.robotoFlex(
                  color: Color(0xFF969693),
                  fontSize: iswidth ? 96 : 45,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                "WE CAN HELP \n YOU",
                style: GoogleFonts.robotoFlex(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: iswidth ? 96 : 45,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                    iconSize: 50,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                    iconSize: 45,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
