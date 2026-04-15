import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CustomBottomSheet {
  static void showCongratulations({
    required BuildContext context,
    required String message,
    VoidCallback? onDone,
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
        'https://lottie.host/8040854c-8822-4a00-9943-4f95e54d72bc/4uH8FpLz6w.json',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.check_circle,
            size: 100,
            color: Color(0xFF22C55E),
          );
        },
      ),
      actions: [
        IconsButton(
          onPressed: () {
            if (context.mounted && Navigator.canPop(context)) {
              Navigator.pop(context); // Always close the dialog first
            }
            if (onDone != null) {
              onDone();
            }
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
