import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertHelpcenterPage extends StatefulWidget {
  const AdvertHelpcenterPage({super.key});

  @override
  State<AdvertHelpcenterPage> createState() => _AdvertHelpcenterPageState();
}

class _AdvertHelpcenterPageState extends State<AdvertHelpcenterPage> {
  void _launchWhatsApp() async {
    const String whatsappNumber = "252615930944";
    final String url =
        "https://wa.me/$whatsappNumber?text=Hello Deero Advert, I'm interested in your services.";

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ma suurtagelin in la furo WhatsApp")),
        );
      }
    }
  }

  void _showSupportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 40,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              _buildSupportOption(
                icon: LineIcons.mobilePhone,
                title: "Call Us",
                subtitle: "Tap to call us now",
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl('tel:+252615930944');
                },
              ),
              const SizedBox(height: 12),
              _buildSupportOption(
                icon: LineIcons.envelope,
                title: "SMS",
                subtitle: "Leave us a message.",
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl('sms:+252615930944');
                },
              ),
              const SizedBox(height: 12),
              _buildSupportOption(
                icon: LineIcons.whatSApp,
                title: "WhatsApp",
                subtitle: "Contact us on WhatsApp now",
                onTap: () {
                  Navigator.pop(context);
                  _launchWhatsApp();
                },
              ),
              const SizedBox(height: 12),
              _buildSupportOption(
                icon: LineIcons.commentDots,
                title: "Make Suggestion",
                subtitle: "Send us your feedback",
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl('mailto:support@deero.com?subject=App Suggestion');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchUrl(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Action failed to open")));
      }
    }
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xffEF7044),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSupportOptions(context),
        backgroundColor: const Color(0xff660E0D),
        child: const Icon(LineIcons.headset, color: Colors.white, size: 30),
      ),
      appBar: AppBar(
        title: Text(
          "Help Center",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image / Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(color: Color(0xffFFF6F0)),
              child: Column(
                children: [
                  Icon(
                    LineIcons.questionCircle,
                    size: 80,
                    color: const Color(0xffEF7044),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "How can we help you?",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Search our knowledge base or contact support.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // FAQ Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Frequently Asked Questions",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildFaqItem(
                    "How do I reset my password?",
                    "You can reset your password by clicking on 'Forgot Password' on the login screen and following the email instructions.",
                  ),
                  _buildFaqItem(
                    "How can I contact support?",
                    "You can reach out to our support team directly via the WhatsApp button on the bottom of the home screen.",
                  ),
                  _buildFaqItem(
                    "Where do I find my recent domains?",
                    "All your purchased domains can be found under the 'My Domains' section in the side menu.",
                  ),

                  const SizedBox(height: 30),

                  // Contact Support Cards
                  Text(
                    "Contact Us",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildContactCard(
                          icon: LineIcons.envelope,
                          title: "Email",
                          subtitle: "support@deero.com",
                          color: const Color(0xff660E0D),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildContactCard(
                          icon: LineIcons.phone,
                          title: "Phone",
                          subtitle: "+252 61 0000000",
                          color: const Color(0xffEF7044),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        iconColor: const Color(0xffEF7044),
        collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Text(
            answer,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
