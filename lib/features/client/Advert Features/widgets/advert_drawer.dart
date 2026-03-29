import 'package:animate_do/animate_do.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:deero_enterprise_app/features/auth/pages/login_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_aboutpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_careerpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_historypage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_newspage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_notificationpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_portfoliopage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdvertDrawer extends StatelessWidget {
  const AdvertDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final isLoggedIn = box.hasData(isLogged);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person_outline_rounded,
                    title: "My Account",
                    delay: 100,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            isLoggedIn ? Profilepage() : LoginPage(),
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.history,
                    title: "Portfolio",
                    delay: 150,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertPortfoliopage(),
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.history,
                    title: "History",
                    delay: 150,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertHistorypage(),
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.notifications_none_rounded,
                    title: "Notifications",
                    delay: 200,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertNotificationpage(),
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.newspaper_rounded,
                    title: "Latest News",
                    delay: 300,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertNewspage(),
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.work_outline_rounded,
                    title: "Careers",
                    delay: 400,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertCareerPage(),
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    title: "About Us",
                    delay: 500,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertAboutpage(),
                      ),
                    ),
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.help_outline_rounded,
                    title: "Help Center",
                    delay: 600,
                    onTap: () {},
                  ),
                  const Divider(height: 40, thickness: 0.5),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.logout_rounded,
                    title: "Log Out",
                    delay: 700,
                    onTap: () {
                      userProvider.logout();
                      Navigator.pop(context); // Close drawer
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Logged out successfully"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Version Info
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Version 1.0.0",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      decoration: const BoxDecoration(
        // color: Color(0xff651313),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Image.asset(fullAdvertLogo, width: 150, height: 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int delay,
    required VoidCallback onTap,
  }) {
    return FadeInLeft(
      delay: Duration(milliseconds: delay),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xff651313).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: const Color(0xff651313)),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.withOpacity(0.3),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
