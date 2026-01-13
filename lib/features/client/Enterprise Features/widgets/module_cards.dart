import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ModuleCards extends StatelessWidget {
  const ModuleCards({
    super.key,
    required this.moduleName,
    required this.moduleImage,
    required this.bgcolor,
    required this.onTap
  });
  final String moduleName;
  final String moduleImage;
  final Color bgcolor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: bgcolor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset(moduleImage, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 5),
          Text(moduleName, style: GoogleFonts.poppins(fontSize: 12)),
        ],
      ),
    );
  }
}
