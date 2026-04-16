import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/core/themes/color_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/navigation_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_aboutpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_homepage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_hostingpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_profilepage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_servicepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:io';

class AdvertNavigationpage extends StatefulWidget {
  AdvertNavigationpage({super.key});

  @override
  State<AdvertNavigationpage> createState() => _AdvertNavigationpageState();
}

class _AdvertNavigationpageState extends State<AdvertNavigationpage> {
  bool _socialFabOpen = false;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Could not open link")));
      }
    }
  }

  Future<void> _openInstagram() async {
    if (!await launchUrl(
      Uri.parse(kAdvertSocialInstagramUrl),
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Could not open Instagram")));
      }
    }
  }

  Widget _miniSocialButton({
    IconData? icon,
    String? imagePath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: color,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            onTap();
            setState(() => _socialFabOpen = false);
          },
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: imagePath != null
                  ? Image.asset(imagePath, width: 28, height: 28)
                  : Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages(int serviceIndex) => [
    AdvertHomepage(),
    AdvertAboutpage(),
    AdvertServicepage(initialIndex: serviceIndex),
    AdvertHostingpage(),
    const AdvertProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {

        final pages = _buildPages(navProvider.serviceInitialIndex);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (navProvider.currentIndex != 0) {
              // Redirect to Home if not already there
              navProvider.setPageIndex(0);
            } else {
              // Show beautiful exit dialog
              _showExitDialog(context);
            }
          },
          child: Scaffold(
            body: pages[navProvider.currentIndex],
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_socialFabOpen) ...[
                    _miniSocialButton(
                      icon: LineIcons.whatSApp,
                      color: const Color(0xFF25D366),
                      onTap: () => _openUrl(kAdvertSocialWhatsAppUrl),
                    ),
                    _miniSocialButton(
                      icon: LineIcons.music,
                      imagePath: "images/advertimages/tiktok.png",
                      color: const Color(0xFF000000),
                      onTap: () => _openUrl(kAdvertSocialTikTokUrl),
                    ),
                    _miniSocialButton(
                      icon: LineIcons.behance,
                      color: const Color(0xFF1769FF),
                      onTap: () => _openUrl(kAdvertSocialBehanceUrl),
                    ),
                    _miniSocialButton(
                      icon: LineIcons.instagram,
                      color: const Color(0xFFE1306C), // Official Instagram Magenta
                      onTap: _openInstagram,
                    ),
                  ],
                  FloatingActionButton(
                    onPressed: () =>
                        setState(() => _socialFabOpen = !_socialFabOpen),
                    backgroundColor: const Color(0xffEF7044),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      _socialFabOpen
                          ? IconlyLight.close_square
                          : IconlyLight.chat,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: bgColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 3,
                  ),
                  child: GNav(
                    selectedIndex: navProvider.currentIndex,
                    onTabChange: (value) {
                      Provider.of<NavigationProvider>(
                        context,
                        listen: false,
                      ).setPageIndex(value);
                    },
                    hoverColor: Colors.transparent,
                    haptic: true,
                    tabBorderRadius: 35,
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100),
                    gap: 4,
                    color: Colors.black,
                    activeColor: const Color(0xffEF7044),
                    iconSize: 22,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    tabs: [
                      const GButton(icon: IconlyLight.home, text: 'Home'),
                      const GButton(
                        icon: IconlyLight.info_square,
                        text: 'About',
                      ),
                      const GButton(
                        icon: IconlyLight.category,
                        text: 'Service',
                      ),
                      GButton(
                        icon: Icons.circle,
                        leading: Image.asset(
                          "images/advertimages/hosting.png",
                          width: 24,
                          height: 24,
                          color: navProvider.currentIndex == 3
                              ? const Color(0xffEF7044)
                              : Colors.black,
                        ),
                        text: 'Hosting',
                      ),
                      const GButton(icon: IconlyLight.profile, text: 'Profile'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FadeInScale(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon or Image
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffEF7044).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    IconlyBold.logout,
                    color: Color(0xffEF7044),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Are you sure?",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff651313),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Do you want to exit the app?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "No",
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => exit(0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEF7044),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Yes",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FadeInScale extends StatelessWidget {
  final Widget child;
  const FadeInScale({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: ZoomIn(duration: const Duration(milliseconds: 400), child: child),
    );
  }
}
