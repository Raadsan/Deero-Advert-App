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
              tabBackgroundColor: Color(0xFF651313),
              curve: Curves.ease, // tab animation curves
              duration: Duration(milliseconds: 100), // tab animation duration
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
                GButton(icon: LineIcons.infoCircle, text: 'About'),
                GButton(icon: LineIcons.cubes, text: 'Service'),
                GButton(icon: LineIcons.server, text: 'Hosting'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
