import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvertHostingpage extends StatelessWidget {
  const AdvertHostingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Hosting",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
