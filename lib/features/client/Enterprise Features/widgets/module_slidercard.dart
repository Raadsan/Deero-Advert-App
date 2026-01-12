import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModuleSliderCard extends StatelessWidget {
  const ModuleSliderCard({
    super.key,
    required this.moduleName,
    required this.moduleImage,
    required this.moduleDescription,
  });
  final String moduleName;
  final String moduleImage;
  final String moduleDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffF3EBE2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moduleName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      moduleDescription,
                      style: GoogleFonts.poppins(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Image.asset(moduleImage, width: 100, height: 100)),
        ],
      ),
    );
  }
}
