
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_chat_list_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/company_contact_provider.dart';
import 'package:iconly/iconly.dart';

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

    // Fetch contacts on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyContactProvider>().fetchContacts();
    });
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
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSupportOptions(context),
        backgroundColor: const Color(0xff660E0D),
        child: const Icon(LineIcons.headset, color: Colors.white, size: 30),
      ),
      body: Consumer<CompanyContactProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              // ── Dynamic Header ──
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                centerTitle: true,
                elevation: 0,
                backgroundColor: const Color(0xff660E0D),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    "Help Center",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff660E0D), Color(0xffEF7044)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(IconlyLight.arrow_left, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── FAQ Section ──
                      _buildSectionTitle(
                        "Frequently Asked Questions",
                        const Color(0xffEF7044),
                      ),
                      const SizedBox(height: 16),
                      _buildFaqItem(
                        "How do I reset my password?",
                        "You can reset your password by clicking on 'Forgot Password' on the login screen and following the email instructions.",
                        IconlyLight.discovery,
                      ),
                      _buildFaqItem(
                        "How can I contact support?",
                        "You can reach out to our support team directly via the WhatsApp button or the Help Center contact options.",
                        IconlyLight.call,
                      ),
                      _buildFaqItem(
                        "Where do I find my recent domains?",
                        "All your purchased domains can be found under the 'My Domains' section in the navigation menu.",
                        IconlyLight.discovery,
                      ),
                      _buildFaqItem(
                        "How do I update my account info?",
                        "Go to Settings > Profile and tap 'Edit Profile' to update your personal information.",
                        IconlyLight.profile,
                      ),

                      const SizedBox(height: 32),

                      // ── Contact Cards Section (from screenshot) ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle(
                            "Get in Touch",
                            const Color(0xffEF7044),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdvertChatListPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              IconlyLight.chat,
                              size: 18,
                              color: Color(0xff660E0D),
                            ),
                            label: Text(
                              "Live Chat",
                              style: GoogleFonts.poppins(
                                color: const Color(0xff660E0D),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(
                                0xff660E0D,
                              ).withOpacity(0.1),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                        onTap: () => _launchUrl(
                          'https://www.instagram.com/deeroadvert/',
                        ),
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
                        onTap: () => _launchUrl(
                          'https://www.facebook.com/share/18fKLYZvqV/',
                        ),
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
                        onTap: () =>
                            _launchUrl('https://www.behance.net/deeroadvert/'),
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
                        onTap: () => _launchUrl(
                          'https://www.tiktok.com/@deeroadverts?_r=1&_t=ZS-95TiDt6Svki',
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color accentColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialCard(dynamic contact) {
    IconData icon;
    String title = contact.type.toUpperCase();
    String subtitle = "Join our community on ${contact.type}";

    switch (contact.type.toLowerCase()) {
      case 'facebook':
        icon = LineIcons.facebook;
        subtitle = "Join our community";
        break;
      case 'instagram':
        icon = LineIcons.instagram;
        subtitle = "Follow us for behind the scenes";
        break;
      case 'behance':
        icon = LineIcons.behance;
        subtitle = "View our creative portfolio";
        break;
      case 'tiktok':
        icon = LineIcons.music;
        subtitle = "Watch our latest videos";
        break;
      case 'linkedin':
        icon = LineIcons.linkedin;
        subtitle = "Professional updates";
        break;
      case 'whatsapp':
        icon = LineIcons.whatSApp;
        subtitle = "Instant support";
        break;
      default:
        icon = IconlyLight.message;
    }

    return GestureDetector(
      onTap: () => _launchUrl(contact.value),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff660E0D), Color(0xff8B1210)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff660E0D).withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
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
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              IconlyLight.arrow_right,
              color: Colors.white.withOpacity(0.6),
              size: 20,
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
          trailing: const Icon(
            IconlyLight.arrow_down_2,
            size: 18,
            color: Colors.grey,
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
