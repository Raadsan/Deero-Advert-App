import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_homepage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_notificationpage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_orderpage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/pages/enterprise_profilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EnterpriseNavigationpage extends StatefulWidget {
  EnterpriseNavigationpage({super.key});

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
              hoverColor: Colors.cyan, // tab button hover color
              haptic: true, // haptic feedback
              tabBorderRadius: 35,
              tabBackgroundColor: Colors.indigo.shade300,
              tabActiveBorder: Border.all(color: Colors.grey, width: 1),
              curve: Curves.easeIn, // tab animation curves
              duration: Duration(microseconds: 1000), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Colors.black, // unselected icon color
              activeColor: Colors.white, // selected icon and text color
              iconSize: 24, // tab button icon size
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ), // navigation bar padding
              tabs: [
                GButton(icon: LineIcons.home, text: 'Home'),
                GButton(icon: LineIcons.shoppingBag, text: 'Order'),
                GButton(icon: LineIcons.bell, text: 'Notification'),
                GButton(icon: LineIcons.user, text: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



  // bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: currentPage,
  //       onTap: (page) => {
  //         setState(() {
  //           currentPage = page;
  //         }),
  //       },
  //       type: BottomNavigationBarType.fixed,
  //       items: [
  //         BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
  //         BottomNavigationBarItem(
  //           icon: Icon(LucideIcons.shoppingBag),
  //           label: "Order",
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(LucideIcons.messageCircle),
  //           label: "Notification",
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(LucideIcons.user2),
  //           label: "Profile",
  //         ),
  //       ],
  //     ),