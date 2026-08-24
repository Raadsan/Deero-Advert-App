import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:deero_advert_app/features/auth/pages/login_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_aboutpage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_bonushistory_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_historypage.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_helpcenter_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_privacy_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_profile_details_page.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/pages/advert_terms_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AdvertProfilePage extends StatelessWidget {
  const AdvertProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final isLoggedIn = box.hasData(isLogged);
    final Color lightHeaderColor = const Color(
      0xffE9F2F2,
    ); // Very light teal/grey

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  // Header Section
                  Center(
                    child: Column(
                      children: [
                        Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF3F4F6),
                              image:
                                  (userProvider.userModel?.user?.image != null && userProvider.userModel!.user!.image!.isNotEmpty)
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        userProvider.userModel!.user!.image!
                                                .startsWith('http')
                                            ? userProvider
                                                .userModel!
                                                .user!
                                                .image!
                                            : BaseUrl +
                                                userProvider
                                                    .userModel!
                                                    .user!
                                                    .image!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: (userProvider.userModel?.user?.image == null || userProvider.userModel?.user?.image?.isEmpty == true)
                                ? Center(
                                    child: Text(
                                      userProvider.userModel?.user?.fullname != null &&
                                              userProvider.userModel!.user!.fullname!.isNotEmpty
                                          ? userProvider.userModel!.user!.fullname!
                                                .substring(0, 1)
                                                .toUpperCase()
                                          : "U",
                                      style: GoogleFonts.outfit(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF374151),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            userProvider.userModel?.user?.fullname ?? "Guest User",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userProvider.userModel?.user?.phone ?? "Login to see details",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Menu Sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Account"),
                        _buildMenuItem(
                          icon: IconlyLight.profile,
                          title: "Profile",
                          onTap: () {
                            if (userProvider.userModel?.user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdvertProfileDetailsPage(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.bookmark,
                          title: "Transactions",
                          onTap: () {
                            if (userProvider.userModel?.user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdvertHistorypage(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.ticket,
                          title: "My Bonuses",
                          onTap: () {
                            if (userProvider.userModel?.user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdvertBonusHistoryPage(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 25),

                        _buildSectionHeader("About"),
                        _buildMenuItem(
                          icon: IconlyLight.danger,
                          title: "About App",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdvertAboutpage(),
                            ),
                          ),
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.document,
                          title: "Terms & Conditions",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdvertTermsPage(),
                            ),
                          ),
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.danger,
                          title: "Privacy Policy",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdvertPrivacyPage(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        _buildSectionHeader("Support"),
                        _buildMenuItem(
                          icon: IconlyLight.message,
                          title: "Contact Us",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdvertHelpcenterPage(),
                            ),
                          ),
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.heart,
                          title: "Rate App",
                          onTap: () async {
                            final url = Uri.parse(
                              "https://play.google.com/store/apps/details?id=com.raadsan.deeroadvert",
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Could not open Play Store."),
                                ),
                              );
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.star,
                          title: "Rate Website",
                          onTap: () async {
                            final url = Uri.parse(
                              "https://g.page/r/CVxJJpIWP25NEBM/review",
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Could not open link."),
                                ),
                              );
                            }
                          },
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.send,
                          title: "Share App",
                          onTap: () {
                            Share.share(
                              "Download Deero Advert app from Play Store: https://play.google.com/store/apps/details?id=com.raadsan.deeroadvert",
                              subject: "Deero Advert App",
                            );
                          },
                        ),

                        const SizedBox(height: 25),

                        _buildSectionHeader("Account Management"),
                        userProvider.userModel?.user != null
                            ? _buildMenuItem(
                                icon: IconlyLight.logout,
                                title: "Logout",
                                isDanger: true,
                                onTap: () =>
                                    _showLogoutDialog(context, userProvider),
                              )
                            : _buildMenuItem(
                                icon: IconlyLight.login,
                                title: "Login",
                                isDanger: false,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF9CA3AF),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final Color itemColor = isDanger
        ? const Color(0xFFEF4444)
        : const Color(0xFF6B7280);
    final Color textColor = isDanger
        ? const Color(0xFFEF4444)
        : const Color(0xFF374151);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
            Icon(
              IconlyLight.arrow_right_2,
              size: 16,
              color: const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(IconlyLight.profile, size: 80, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 24),
            Text(
              "Not Logged In",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff660E0D),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Log In Now",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Logout",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              userProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: Text(
              "Logout",
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
