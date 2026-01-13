import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_homepage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_notificationpage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_orderpage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_profilepage.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EnterpriseNavigationpage extends StatefulWidget {
  const EnterpriseNavigationpage({super.key});

  @override
  State<EnterpriseNavigationpage> createState() =>
      _EnterpriseNavigationpageState();
}

class _EnterpriseNavigationpageState extends State<EnterpriseNavigationpage> {
  @override
  List<Widget> _pages = [
    EnterpriseHomepage(),
    EnterpriseOrderpage(),
    EnterpriseNotificationpage(),
    EnterpriseProfilepage(),
  ];

  int currentPage = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) => {
          setState(() {
            currentPage = page;
          }),
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.shoppingBag),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user2),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
