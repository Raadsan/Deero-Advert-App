import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jovial_svg/jovial_svg.dart';

class AdvertAboutpage extends StatelessWidget {
  const AdvertAboutpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color(0xff111827),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ScalableImageWidget.fromSISource(
                  si: ScalableImageSource.fromSvgHttpUrl(
                    Uri.parse('https://jovial.com/images/jupiter.svg'),
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.justify,
                        "Deero Advertising Agency is one of the innovative digital service providers in Somalia, founded in 2019 to offer a wide range of digital creative services.  deero Advert is the first advertising company that provides a wide variety of one-stop digital creative services (1-stop agency: marketing, creative, web, and video) in Somalia. ",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Color(0xFF651313),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
