import 'package:deero_enterprise_app/features/auth/pages/login_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class AdvertNotificationpage extends StatefulWidget {
  const AdvertNotificationpage({super.key});

  @override
  State<AdvertNotificationpage> createState() => _AdvertNotificationpageState();
}

class _AdvertNotificationpageState extends State<AdvertNotificationpage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NotificationProvider>();
      provider.getAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          final notificationList =
              notificationProvider.notificationModel?.data ?? [];

          // Full-page Loading State
          if (notificationProvider.isLoading && notificationList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffEF7044)),
            );
          }

          // Error State: Check for 401 Unauthorized
          if (notificationProvider.error != null && notificationList.isEmpty) {
            if (notificationProvider.error!.contains("401")) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFF6F0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LineIcons.userLock,
                          size: 60,
                          color: const Color(0xffEF7044),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Authentication Required",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "You are not logged in. Please sign up or log in to view and receive all notifications securely.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          ).then((_) {
                            notificationProvider.getAllNotifications();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff660E0D),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Other errors
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LineIcons.exclamationCircle,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Error loading notifications",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notificationProvider.error ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          notificationProvider.getAllNotifications(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEF7044),
                        minimumSize: const Size(120, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Retry",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (notificationList.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await notificationProvider.getAllNotifications();
              },
              color: const Color(0xffEF7044),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.bellSlash,
                          size: 60,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No notifications found",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await notificationProvider.getAllNotifications();
            },
            color: const Color(0xffEF7044),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade200, height: 1, indent: 80),
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notificationList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF6F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LineIcons.bell,
                      color: Color(0xffEF7044),
                      size: 26,
                    ),
                  ),
                  title: Text(
                    notification.title ?? "No title",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.message ?? "No message",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Ends on: ${notification.endDate}",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Navigate to details if needed
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
