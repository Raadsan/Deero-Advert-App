import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class AdvertPrivacyPage extends StatelessWidget {
  const AdvertPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Matters",
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xff111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Last updated: April 2026",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 32),
            _buildPrivacySection(
              "1. Information We Collect",
              "We collect information you provide directly to us, such as when you create an account, update your profile, or purchase a service. This includes your name, email, and phone number.",
            ),
            _buildPrivacySection(
              "2. How We Use Information",
              "We use the information to provide, maintain, and improve our services, process transactions, and send you technical notices and support messages.",
            ),
            _buildPrivacySection(
              "3. Sharing of Information",
              "We do not share your personal information with third parties except as required by law or to provide the services you have requested (e.g., payment processing).",
            ),
            _buildPrivacySection(
              "4. Data Security",
              "We take reasonable measures to help protect your information from loss, theft, misuse, and unauthorized access.",
            ),
            _buildPrivacySection(
              "5. Your Choices",
              "You may update or correct your profile information at any time by logging into your account. You can also request to delete your account through the app settings.",
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(IconlyLight.shield_done, color: Color(0xff660E0D), size: 30),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Your data is encrypted and stored securely following industry standards.",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xff4B5563),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xff660E0D),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.6,
              color: const Color(0xff4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
