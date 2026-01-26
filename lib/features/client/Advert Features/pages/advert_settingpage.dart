import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:deero_enterprise_app/features/auth/pages/login_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_aboutpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_careerpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_newspage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdvertSettingpage extends StatelessWidget {
  const AdvertSettingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final box = GetStorage();
        final isLoggedIn = box.hasData(isLogged);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              "Settings",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xff111827),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  AdvertSettingCard(
                    icon: Icons.person_outline_rounded,
                    title: "My Account",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            isLoggedIn ? Profilepage() : LoginPage(),
                      ),
                    ),
                  ),
                  AdvertSettingCard(
                    icon: Icons.notifications_none_rounded,
                    title: "Notifications",
                    onTap: () {},
                  ),
                  AdvertSettingCard(
                    icon: Icons.newspaper_rounded,
                    title: "Latest News",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertNewspage(),
                      ),
                    ),
                  ),
                  AdvertSettingCard(
                    icon: Icons.work_outline_rounded,
                    title: "Careers",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertCareerPage(),
                      ),
                    ),
                  ),
                  AdvertSettingCard(
                    icon: Icons.info_outline_rounded,
                    title: "About Us",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvertAboutpage(),
                      ),
                    ),
                  ),
                  AdvertSettingCard(
                    icon: Icons.help_outline_rounded,
                    title: "Help Center",
                    onTap: () {},
                  ),
                  AdvertSettingCard(
                    icon: Icons.logout_rounded,
                    title: "Log Out",
                    onTap: () {
                      userProvider.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Logged out successfully"),
                        ),
                      );
                    },
                    showArrow: false,
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Version 1.0.0",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AdvertSettingCard extends StatelessWidget {
  const AdvertSettingCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor = const Color(0xff660E0D),
    this.isDestructive = false,
    this.showArrow = true,
  });

  final IconData icon;
  final String title;
  final Function()? onTap;
  final Color iconColor;
  final bool isDestructive;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xffFCD7C3).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: Colors.black),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff1f2937),
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
