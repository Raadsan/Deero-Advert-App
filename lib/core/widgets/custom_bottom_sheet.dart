import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CustomBottomSheet {
  static void showCongratulations({
    required BuildContext context,
    required String message,
  }) {
    Dialogs.bottomMaterialDialog(
      msg: message,
      title: 'Congratulations',
      context: context,
      color: Colors.white,
      titleStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: const Color(0xff111827),
      ),
      msgStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
      lottieBuilder: Lottie.network(
        'https://assets3.lottiefiles.com/packages/lf20_toum7vvy.json', // Success stars
        fit: BoxFit.contain,
      ),
      actions: [
        IconsButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Done',
          iconData: Icons.check_circle_outline,
          color: const Color(0xFF22C55E),
          textStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          iconColor: Colors.white,
        ),
      ],
    );
  }
}
