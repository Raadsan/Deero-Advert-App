import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/core/themes/color_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/navigation_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_homepage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_hostingpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_profilepage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_servicepage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_vediospage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open Instagram")),
        );
      }
    }
  }
  Future<void> _openlinkedin() async {
    if (!await launchUrl(
      Uri.parse(kAdvertSocialLinkedInUrl),
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open Linkedin")),
        );
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
    AdvertServicepage(initialIndex: serviceIndex),
    AdvertVediospage(),
    AdvertHostingpage(),
    const AdvertProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        final pages = _buildPages(navProvider.serviceInitialIndex);
        final isVideoPage = navProvider.currentIndex == 2;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: isVideoPage ? Colors.black : bgColor,
            systemNavigationBarIconBrightness: isVideoPage
                ? Brightness.light
                : Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isVideoPage
                ? Brightness.light
                : Brightness.dark,
          ),
          child: PopScope(
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: navProvider.currentIndex == 2
                  ? null
                  : Padding(
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
                              color: const Color(
                                0xFFE1306C,
                              ), // Official Instagram Magenta
                              onTap: _openInstagram,
                            ),
                            _miniSocialButton(
                              icon: LineIcons.linkedin,
                              color: const Color(
                                0xFF0072B1,
                              ), // Official Instagram Magenta
                              onTap: _openlinkedin,
                            ),
                          ],
                          FloatingActionButton(
                            onPressed: () => setState(
                              () => _socialFabOpen = !_socialFabOpen,
                            ),
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
                  color: navProvider.currentIndex == 2 ? Colors.black : bgColor,
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
                      horizontal: 10.0,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          index: 0,
                          icon: IconlyLight.home,
                          activeIcon: IconlyBold.home,
                          label: 'Home',
                          navProvider: navProvider,
                        ),
                        _buildNavItem(
                          index: 1,
                          icon: IconlyLight.category,
                          activeIcon: IconlyBold.category,
                          label: 'Service',
                          navProvider: navProvider,
                        ),
                        _buildVideoNavItem(
                          index: 2,
                          label: 'Videos',
                          navProvider: navProvider,
                        ),
                        _buildHostingNavItem(
                          index: 3,
                          label: 'Hosting',
                          navProvider: navProvider,
                        ),
                        _buildNavItem(
                          index: 4,
                          icon: IconlyLight.profile,
                          activeIcon: IconlyBold.profile,
                          label: 'Profile',
                          navProvider: navProvider,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required NavigationProvider navProvider,
  }) {
    bool isSelected = navProvider.currentIndex == index;
    bool isVideoPage = navProvider.currentIndex == 2;
    Color color = isSelected
        ? const Color(0xffEF7044)
        : (isVideoPage ? Colors.white70 : Colors.grey);

    return InkWell(
      onTap: () => navProvider.setPageIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSelected ? activeIcon : icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoNavItem({
    required int index,
    required String label,
    required NavigationProvider navProvider,
  }) {
    bool isSelected = navProvider.currentIndex == index;
    bool isVideoPage = navProvider.currentIndex == 2;
    Color color = isSelected
        ? const Color(0xffEF7044)
        : (isVideoPage ? Colors.white70 : Colors.grey);

    return InkWell(
      onTap: () => navProvider.setPageIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xffEF7044)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Icon(IconlyBold.video, size: 20, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostingNavItem({
    required int index,
    required String label,
    required NavigationProvider navProvider,
  }) {
    bool isSelected = navProvider.currentIndex == index;
    bool isVideoPage = navProvider.currentIndex == 2;
    Color color = isSelected
        ? const Color(0xffEF7044)
        : (isVideoPage ? Colors.white70 : Colors.grey);

    return InkWell(
      onTap: () => navProvider.setPageIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "images/advertimages/hosting.png",
            width: 24,
            height: 24,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
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
