import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModuleCards extends StatelessWidget {
  const ModuleCards({
    super.key,
    required this.moduleName,
    required this.moduleImage,
  });
  final String moduleName;
  final String moduleImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 120,
      decoration: BoxDecoration(
        color: Color(0xffDFD7D0).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Image.asset(moduleImage, width: 35, height: 35),
          ),
          SizedBox(height: 5),
          Text(moduleName, style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }
}
