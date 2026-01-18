import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdvertHomepage extends StatelessWidget {
  const AdvertHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 30)),
        automaticallyImplyLeading: false,
        title: Image.asset(fullAdvertLogo, width: 170, height: 50),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF651313),
                      Color(0xFF651313),
                      Color(0xFFEB4724),
                    ],
                    stops: [0.0, 0.6, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Event Branding",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "We offer a full suite of event branding and consulting services, including event digital strategy,",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Image.asset(
                                "images/advertimages/event.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffFCD7C3).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Your Domain Today!",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Search Your Domain",
                                fillColor: Colors.white,
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff660E0D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Search",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Our Services", style: GoogleFonts.poppins(fontSize: 17)),
              SizedBox(height: 10),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffDFD7D0).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset(
                                "images/advertimages/graphicdesign.svg",
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Graphic Design",
                                style: GoogleFonts.poppins(fontSize: 11),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                "images/advertimages/digitalmarketing.svg",
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Digital Marketing",
                                style: GoogleFonts.poppins(fontSize: 11),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                "images/advertimages/websolution.svg",
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Web Solutions",
                                style: GoogleFonts.poppins(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset(
                                "images/advertimages/motiongraphics.svg",
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Motion Graphics",
                                style: GoogleFonts.poppins(fontSize: 11),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                "images/advertimages/eventbranding.svg",
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Event Branding",
                                style: GoogleFonts.poppins(fontSize: 11),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                "images/advertimages/digitalconsulting.svg",
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Digital Consulting",
                                style: GoogleFonts.poppins(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Our Major Clients",
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                child: CarouselSlider(
                  items: [
                    Image.asset("images/advertimages/2.png"),
                    Image.asset("images/advertimages/3.png"),
                    Image.asset("images/advertimages/4.png"),
                    Image.asset("images/advertimages/5.png"),
                    Image.asset("images/advertimages/6.png"),
                  ],
                  options: CarouselOptions(
                    height: 120,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.4,
                    autoPlay: true,
                    scrollDirection: Axis.horizontal,
                    enlargeFactor: 0.2,
                    scrollPhysics: BouncingScrollPhysics(),
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
