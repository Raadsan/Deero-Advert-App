import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvertSettingpage extends StatelessWidget {
  const AdvertSettingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Setting page",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Color(0xff660E0D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            children: [
              AdvertSettingCard(icon: Icons.account_circle, title: "Account"),
              AdvertSettingCard(icon: Icons.info, title: "About"),
              AdvertSettingCard(icon: Icons.newspaper, title: "News"),
              AdvertSettingCard(icon: Icons.work, title: "career"),
              AdvertSettingCard(
                icon: Icons.notifications,
                title: "Notification",
              ),
              AdvertSettingCard(icon: Icons.help, title: "help center"),
              AdvertSettingCard(icon: Icons.logout, title: "Logout"),
            ],
          ),
        ),
      ),
    );
  }
}

class AdvertSettingCard extends StatelessWidget {
  const AdvertSettingCard({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 25, color: Color(0xff660E0D)),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, letterSpacing: 1),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 20),
    );
  }
}
