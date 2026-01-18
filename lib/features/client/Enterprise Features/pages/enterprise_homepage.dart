import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_homepage.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/widgets/module_cards.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/widgets/module_slidercard.dart';
import 'package:deero_enterprise_app/features/client/Raadsan%20Features/pages/raadsan_homepage.dart';
import 'package:deero_enterprise_app/features/navigation/advert_navigationpage.dart';
import 'package:flutter/material.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterpriseHomepage extends StatelessWidget {
  const EnterpriseHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(enterpriseLogo, width: 30, height: 30),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Faysal Mohamed!",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "614388477",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        shadowColor: Colors.indigo,
        elevation: 2,
        surfaceTintColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 8),
              CarouselSlider(
                options: CarouselOptions(
                  height: 160,
                  viewportFraction: 1,

                  aspectRatio: 16 / 9,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  enableInfiniteScroll: true,
                  scrollDirection: Axis.horizontal,
                  initialPage: 0,
                  onPageChanged: (index, reason) {},
                ),
                items: [
                  ModuleSliderCard(
                    moduleName: "Deero Advert",
                    moduleImage: fullAdvertLogo,
                    moduleDescription:
                        "A digital advertising platform that helps businesses grow through smart marketing solutions.",
                  ),
                  ModuleSliderCard(
                    moduleName: "Deero Institute",
                    moduleImage: fullInstituteLogo,
                    moduleDescription:
                        "A professional training institute focused on practical skills and career-ready education",
                  ),
                ],
              ),
              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ModuleCards(
                    moduleName: "Raadsan Tech",
                    moduleImage: raadsanLogo,
                    bgcolor: Color(0xffFDC210),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RaadsanHomepage()),
                    ),
                  ),
                  ModuleCards(
                    moduleName: "Deero Advert",
                    moduleImage: advertLogo,
                    bgcolor: Color(0xff651210),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdvertNavigationpage()),
                    ),
                  ),
                  ModuleCards(
                    moduleName: "Deero Institute",
                    moduleImage: instituteLogo,
                    bgcolor: Color(0xff003D9E),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RaadsanHomepage()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              FadeInUp(
                duration: const Duration(milliseconds: 750),
                child: Row(
                  children: [
                    Expanded(
                      child: BuildStatItem(
                        color: const Color(0xFF603913),
                        val: 10,
                        suffix: "K+",
                        label: "Clients",
                      ),
                    ),
                    Expanded(
                      child: BuildStatItem(
                        color: const Color(0xFFC49A6C),
                        val: 50,
                        suffix: "+",
                        label: "Experts",
                      ),
                    ),
                    Expanded(
                      child: BuildStatItem(
                        val: 100,
                        suffix: "%",
                        label: "Secure",
                        color: const Color(0xFF603913),
                      ),
                    ),
                    Expanded(
                      child: BuildStatItem(
                        val: 24,
                        suffix: "/7",
                        label: "Support",
                        color: const Color(0xFFC49A6C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildStatItem extends StatelessWidget {
  const BuildStatItem({
    super.key,
    required this.val,
    required this.suffix,
    required this.label,
    required this.color,
  });
  final double val;
  final String suffix;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: val),
            duration: const Duration(seconds: 2),
            curve: Curves.easeOutExpo,
            builder: (context, value, child) {
              return Text(
                "${value.toInt()}$suffix",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              );
            },
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
