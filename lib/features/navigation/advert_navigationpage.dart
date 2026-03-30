import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_aboutpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_homepage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_hostingpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_servicepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class AdvertNavigationpage extends StatefulWidget {
  AdvertNavigationpage({super.key});

  @override
  State<AdvertNavigationpage> createState() => _AdvertNavigationpageState();
}

class _AdvertNavigationpageState extends State<AdvertNavigationpage> {
  @override
  List<Widget> _pages = [
    AdvertHomepage(),
    AdvertAboutpage(),
    AdvertServicepage(),
    AdvertHostingpage(),
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
              selectedIndex: currentPage,
              onTabChange: (value) => {
                setState(() {
                  currentPage = value;
                }),
              },
              hoverColor: Colors.cyan, // tab button hover color
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
                GButton(
                  icon: Icons.circle, // dummy icon
                  leading: Image.asset(
                    "images/advertimages/home.png",
                    width: 20,
                    height: 20,
                    color: currentPage == 0
                        ? const Color(0xffEF7044)
                        : Colors.grey,
                  ),
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.info_outline,
                  iconColor: currentPage == 1
                      ? const Color(0xffEF7044)
                      : Colors.grey,
                  text: 'About',
                ),
                GButton(
                  icon: Icons.circle,
                  leading: Image.asset(
                    "images/advertimages/service.png",
                    width: 24,
                    height: 24,
                    color: currentPage == 2
                        ? const Color(0xffEF7044)
                        : Colors.grey,
                  ),
                  text: 'Service',
                ),
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
