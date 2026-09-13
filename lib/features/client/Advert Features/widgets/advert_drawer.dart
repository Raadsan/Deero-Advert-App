import 'package:animate_do/animate_do.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:deero_advert_app/features/auth/pages/login_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_aboutpage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_careerpage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_helpcenter_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_historypage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_newspage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_notificationpage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_cart_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/cart_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_portfoliopage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_social_mediapage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconly/iconly.dart';

class AdvertDrawer extends StatefulWidget {
  const AdvertDrawer({super.key});

  @override
  State<AdvertDrawer> createState() => _AdvertDrawerState();
}

class _AdvertDrawerState extends State<AdvertDrawer> {
  @override

  Widget build(BuildContext context) {
    // final box = GetStorage();
    // final isLoggedIn = box.hasData(isLogged);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Drawer(
      backgroundColor: const Color(0xFFF9FAFB),
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
                    icon: IconlyLight.info_circle,
                    title: "About Page",
                    delay: 550,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdvertAboutpage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: IconlyLight.paper,
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
                    icon: IconlyLight.work,
                    title: "Careers",
                    delay: 400,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertCareerPage(),
                      ),
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cart, _) {
                      return _buildMenuItem(
                        context: context,
                        icon: IconlyLight.buy,
                        title: "Shopping Cart${cart.totalItems > 0 ? ' (${cart.totalItems})' : ''}",
                        delay: 100,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdvertCartPage(),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: IconlyLight.time_square,
                    title: "Transactions",
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
                    icon: IconlyLight.notification,
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
                    icon: IconlyLight.document,
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
                    icon: IconlyLight.message,
                    title: "Social Media",
                    delay: 600,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdvertSocialMediapage(),
                        ),
                      );
                    },
                  ),

                  _buildMenuItem(
                    context: context,
                    icon: IconlyLight.info_circle,
                    title: "Help Center",
                    delay: 600,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdvertHelpcenterPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 40, thickness: 0.5),
                  _buildMenuItem(
                    context: context,
                    icon: IconlyLight.logout,
                    title: "Log Out",
                    delay: 700,
                    onTap: () => _showLogoutDialog(context, userProvider),
                  ),
                ],
              ),
            ),
          ),

          // Version Info
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Text(
                  "Version 1.0.0",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Developed by Raadsan",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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
        margin: const EdgeInsets.only(bottom: 2),
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
                    IconlyLight.arrow_right_2,
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

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
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
                  "Log Out?",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff651313),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Are you sure you want to log out of your account?",
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
                          "Cancel",
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
                        onPressed: () {
                          userProvider.logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xff660E0D),
                              content: Text("Logged out successfully"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEF7044),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Log Out",
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
