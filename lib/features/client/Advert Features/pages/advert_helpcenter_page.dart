import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertHelpcenterPage extends StatefulWidget {
  const AdvertHelpcenterPage({super.key});

  @override
  State<AdvertHelpcenterPage> createState() => _AdvertHelpcenterPageState();
}

class _AdvertHelpcenterPageState extends State<AdvertHelpcenterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
      backgroundColor: const Color(0xFFF8F9FB),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSupportOptions(context),
        backgroundColor: const Color(0xff660E0D),
        child: const Icon(LineIcons.headset, color: Colors.white, size: 30),
      ),
      appBar: AppBar(
        title: Text(
          "Help Center",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff660E0D), Color(0xffEF7044)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Premium Header Banner ──
            const SizedBox(height: 24),

            const SizedBox(height: 28),

            // ── FAQ Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xffEF7044),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Frequently Asked Questions",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFaqItem(
                    "How do I reset my password?",
                    "You can reset your password by clicking on 'Forgot Password' on the login screen and following the email instructions.",
                    LineIcons.key,
                  ),
                  _buildFaqItem(
                    "How can I contact support?",
                    "You can reach out to our support team directly via the WhatsApp button on the bottom of the home screen.",
                    LineIcons.headset,
                  ),
                  _buildFaqItem(
                    "Where do I find my recent domains?",
                    "All your purchased domains can be found under the 'My Domains' section in the side menu.",
                    LineIcons.globe,
                  ),
                  _buildFaqItem(
                    "How do I update my account info?",
                    "Go to Settings > Profile and tap 'Edit Profile' to update your personal information.",
                    LineIcons.userEdit,
                  ),

                  const SizedBox(height: 28),

                  // ── Follow Us Section ──
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xff660E0D),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Follow Us",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildContactTile(
                    icon: LineIcons.instagram,
                    title: "Instagram",
                    subtitle: "Follow us for behind the scenes",
                    gradientColors: [
                      const Color(0xff660E0D),
                      const Color(0xff660E0D).withOpacity(0.85),
                    ],
                    onTap: () => _launchUrl('https://www.instagram.com/'),
                  ),
                  const SizedBox(height: 12),
                  _buildContactTile(
                    icon: LineIcons.facebook,
                    title: "Facebook",
                    subtitle: "Join our community",
                    gradientColors: [
                      const Color(0xff660E0D),
                      const Color(0xff660E0D).withOpacity(0.75),
                    ],
                    onTap: () => _launchUrl('https://www.facebook.com/'),
                  ),
                  const SizedBox(height: 12),
                  _buildContactTile(
                    icon: LineIcons.behance,
                    title: "Behance",
                    subtitle: "View our creative portfolio",
                    gradientColors: [
                      const Color(0xff660E0D),
                      const Color(0xff660E0D).withOpacity(0.65),
                    ],
                    onTap: () => _launchUrl('https://www.behance.net/'),
                  ),
                  const SizedBox(height: 12),
                  _buildContactTile(
                    icon: LineIcons.music, // Alternative icon for TikTok
                    title: "TikTok",
                    subtitle: "Watch our latest videos",
                    gradientColors: [
                      const Color(0xff660E0D),
                      const Color(0xff660E0D).withOpacity(0.55),
                    ],
                    onTap: () => _launchUrl('https://www.tiktok.com/'),
                  ),

                  const SizedBox(height: 32),

                  // ── Bottom CTA ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF6F0),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xffEF7044).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.comments,
                          size: 40,
                          color: const Color(0xffEF7044),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Still need help?",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Tap the headset button to connect with\nour support team now.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  // ── FAQ Item with icon ──
  Widget _buildFaqItem(String question, String answer, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffEF7044).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xffEF7044)),
          ),
          title: Text(
            question,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          iconColor: const Color(0xffEF7044),
          collapsedIconColor: Colors.grey.shade400,
          childrenPadding: const EdgeInsets.only(
            left: 72,
            right: 16,
            bottom: 16,
          ),
          children: [
            Text(
              answer,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Contact Tile with gradient ──
  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LineIcons.arrowRight,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
