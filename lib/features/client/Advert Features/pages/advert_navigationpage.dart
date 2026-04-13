import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_aboutpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_homepage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_hostingpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_servicepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _openMailto() async {
    if (!await launchUrl(
      kAdvertSocialMailtoUri,
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Could not open email")));
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

  final List<Widget> _pages = [
    AdvertHomepage(),
    AdvertAboutpage(),
    AdvertServicepage(),
    AdvertHostingpage(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPage],
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
                icon: IconlyLight.message,
                color: const Color(0xff660E0D),
                onTap: _openMailto,
              ),
            ],
            FloatingActionButton(
              onPressed: () => setState(() => _socialFabOpen = !_socialFabOpen),
              backgroundColor: const Color(0xffEF7044),
              child: Icon(
                _socialFabOpen ? IconlyLight.close_square : IconlyLight.chat,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
            child: GNav(
              selectedIndex: currentPage,
              onTabChange: (value) => {
                setState(() {
                  currentPage = value;
                }),
              },
              hoverColor: Colors.transparent, // tab button hover color
              haptic: true, // haptic feedback
              tabBorderRadius: 35,
              // tabBackgroundColor: Color(0xFF651313),
              curve: Curves.ease, // tab animation curves
              duration: Duration(milliseconds: 100), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Colors.black, // unselected icon color
              activeColor: Color(0xffEF7044), // selected icon and text color
              iconSize: 24, // tab button icon size
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ), // navigation bar padding
              tabs: [
                GButton(icon: IconlyLight.home, text: 'Home'),
                GButton(icon: IconlyLight.info_square, text: 'About'),
                GButton(icon: IconlyLight.category, text: 'Service'),
                GButton(
                  icon: Icons.circle,
                  leading: Image.asset(
                    "images/advertimages/hosting.png",
                    width: 24,
                    height: 24,
                    color: currentPage == 3
                        ? const Color(0xffEF7044)
                        : Colors.grey,
                  ),
                  text: 'Hosting',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
