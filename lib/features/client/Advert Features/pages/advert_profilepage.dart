import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/core/widgets/safe_network_image.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AdvertProfilePage extends StatefulWidget {
  const AdvertProfilePage({super.key});

  @override
  State<AdvertProfilePage> createState() => _AdvertProfilePageState();
}

class _AdvertProfilePageState extends State<AdvertProfilePage> {
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateSession());
  }

  Future<void> _validateSession() async {
    if (!mounted) return;
    setState(() => _checkingSession = true);
    await context.read<UserProvider>().validateSession();
    if (!mounted) return;
    setState(() => _checkingSession = false);
  }

  Future<void> _openLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    if (!mounted) return;
    await _validateSession();
  }

  /// Shown when guest taps Profile (or other account items).
  Future<void> _showLoginPrompt({
    String message = "Login to view your profile",
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ProfileLoginPromptPage(
          message: message,
          onLogin: () async {
            Navigator.pop(context);
            await _openLogin();
          },
        ),
      ),
    );
    if (!mounted) return;
    await _validateSession();
  }

  void _requireLoginOr(
    VoidCallback action, {
    String loginMessage = "Login to view your profile",
  }) {
    final loggedIn = context.read<UserProvider>().isSessionValid;
    if (loggedIn) {
      action();
    } else {
      _showLoginPrompt(message: loginMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final loggedIn = userProvider.isSessionValid;
          final user = loggedIn ? userProvider.userModel?.user : null;

          if (_checkingSession) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff660E0D)),
            );
          }

          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  // Header — Guest icon + "Guest" when not logged in
                  Center(
                    child: Column(
                      children: [
                        if (loggedIn)
                          SafeNetworkAvatar(
                            imageUrl: () {
                              final img = user?.image;
                              if (img == null || img.isEmpty) return null;
                              return img.startsWith('http')
                                  ? img
                                  : BaseUrl + img;
                            }(),
                            radius: 40,
                            shimmerBase: const Color(0xFFE5E7EB),
                            shimmerHighlight: const Color(0xFFF3F4F6),
                            errorWidget: CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFFF3F4F6),
                              child: Text(
                                user?.fullname?.isNotEmpty == true
                                    ? user!.fullname![0].toUpperCase()
                                    : 'U',
                                style: GoogleFonts.outfit(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                            ),
                          )
                        else
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xFFF3F4F6),
                            child: Icon(
                              IconlyLight.profile,
                              size: 40,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          loggedIn ? (user?.fullname ?? "Guest") : "Guest",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        if (loggedIn) ...[
                          const SizedBox(height: 2),
                          Text(
                            user?.phone ?? "",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Account / About / Support — always visible
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Account"),
                        _buildMenuItem(
                          icon: IconlyLight.profile,
                          title: "Profile",
                          onTap: () => _requireLoginOr(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdvertProfileDetailsPage(),
                              ),
                            );
                          }),
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.bookmark,
                          title: "Transactions",
                          onTap: () => _requireLoginOr(
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdvertHistorypage(),
                                ),
                              );
                            },
                            loginMessage:
                                "Login to view your transaction history",
                          ),
                        ),
                        _buildMenuItem(
                          icon: IconlyLight.ticket,
                          title: "My Bonuses",
                          onTap: () => _requireLoginOr(
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdvertBonusHistoryPage(),
                                ),
                              );
                            },
                            loginMessage: "Login to view your bonuses",
                          ),
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
                            } else if (context.mounted) {
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
                            } else if (context.mounted) {
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
                        if (loggedIn)
                          _buildMenuItem(
                            icon: IconlyLight.logout,
                            title: "Logout",
                            isDanger: true,
                            onTap: () =>
                                _showLogoutDialog(context, userProvider),
                          )
                        else
                          _buildMenuItem(
                            icon: IconlyLight.login,
                            title: "Login",
                            onTap: _openLogin,
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
            const Icon(
              IconlyLight.arrow_right_2,
              size: 16,
              color: Color(0xFF9CA3AF),
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
              Navigator.pop(context);
              setState(() {});
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

/// Login prompt (same style as Transaction History) — opened when guest taps Profile.
class _ProfileLoginPromptPage extends StatelessWidget {
  const _ProfileLoginPromptPage({
    required this.message,
    required this.onLogin,
  });

  final String message;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xff660E0D),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFF3F4F6),
                child: Icon(
                  IconlyLight.profile,
                  size: 40,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Guest",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff111827),
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff660E0D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff660E0D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xff660E0D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Back",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
