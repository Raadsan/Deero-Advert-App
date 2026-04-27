import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class AdvertTermsPage extends StatelessWidget {
  const AdvertTermsPage({super.key});

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
          "Terms & Conditions",
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
              "Terms of Service",
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
            _buildTermSection(
              "1. Acceptance of Terms",
              "By accessing or using Deero Advertising Agency's services, you agree to be bound by these Terms and Conditions. If you do not agree, please do not use our services.",
            ),
            _buildTermSection(
              "2. Description of Service",
              "Deero Advert provides digital advertising, graphic design, social media management, and web development services. We reserve the right to modify or discontinue services at any time.",
            ),
            _buildTermSection(
              "3. User Obligations",
              "Users agree to provide accurate information when registering and using the app. You are responsible for maintaining the confidentiality of your account credentials.",
            ),
            _buildTermSection(
              "4. Payments and Refunds",
              "All payments for services are handled securely. Refund policies vary by service type and will be clearly communicated during the purchase process.",
            ),
            _buildTermSection(
              "5. Intellectual Property",
              "All content, logos, and designs provided by Deero Advert are the intellectual property of Deero Advertising Agency unless otherwise stated.",
            ),
            _buildTermSection(
              "6. Limitation of Liability",
              "Deero Advert shall not be liable for any indirect, incidental, or consequential damages arising from the use of our services.",
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Contact us at support@deeroadvert.com for any questions.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection(String title, String content) {
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
