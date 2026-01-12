import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/widgets/module_cards.dart';
import 'package:deero_enterprise_app/features/client/Enterprise%20Features/widgets/module_slidercard.dart';
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
                    moduleName: "Raadsan Tech",
                    moduleImage: fullRaadsanLogo,
                    moduleDescription:
                        "A technology company providing innovative software and digital solutions for businesses",
                  ),
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
                    bgcolor: Color(0xffC49A6C),
                  ),
                  ModuleCards(
                    moduleName: "Deero Advert",
                    moduleImage: advertLogo,
                    bgcolor: Color(0xffD0AE89),
                  ),
                  ModuleCards(
                    moduleName: "Deero Institute",
                    moduleImage: instituteLogo,
                    bgcolor: Color(0xffC49A6C),
                  ),
                ],
              ),
              SizedBox(height: 20),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
