import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class TransactionReceiptBottomSheet {
  static void show({
    required BuildContext context,
    required String userName,
    required String description,
    required double amount,
    required String date,
    VoidCallback? onDone,
  }) {
    final ScreenshotController screenshotController = ScreenshotController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onDone != null) onDone();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: const Color(0xff660E0D),
                      ),
                    ),
                    Text(
                      "Transfer",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Screenshot(
                        controller: screenshotController,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff660E0D),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade100,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        "images/advertimages/advertlogoico.png",
                                        width: 300,
                                        height: 300,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Transfer Successful",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$ ${amount.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff111827),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      userName.toUpperCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff111827),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    _buildReceiptRow("Transaction date", date),
                                    const SizedBox(height: 16),
                                    _buildReceiptRow("Magaca diraha", userName),
                                    const SizedBox(height: 16),
                                    _buildReceiptRow("Service", description),
                                    const SizedBox(height: 16),
                                    _buildReceiptRow("Price", "\$ ${amount.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')}"),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      child: Divider(
                                        color: Colors.white,
                                        thickness: 1,
                                      ),
                                    ),
                                    _buildReceiptRow(
                                      "Total",
                                      "\$ ${amount.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')}",
                                      isBold: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (onDone != null) onDone();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff660E0D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Done",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff660E0D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          try {
                            final Uint8List? imageBytes =
                                await screenshotController.capture(
                              delay: const Duration(milliseconds: 10),
                            );

                            if (imageBytes != null) {
                              final tempDir = await getTemporaryDirectory();
                              final file = await File(
                                '${tempDir.path}/transaction_receipt.png',
                              ).create();
                              await file.writeAsBytes(imageBytes);

                              await Share.shareXFiles([
                                XFile(file.path),
                              ], text: "Deero Advert Transaction Receipt");
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error sharing image: $e"),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.share, color: Color(0xff660E0D)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: const Color(0xff111827),
            ),
          ),
        ),
      ],
    );
  }
}
