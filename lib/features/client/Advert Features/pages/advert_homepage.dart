import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/advert_slider_card.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';

class AdvertHomepage extends StatefulWidget {
  const AdvertHomepage({super.key});

  @override
  State<AdvertHomepage> createState() => _AdvertHomepageState();
}

class _AdvertHomepageState extends State<AdvertHomepage>
    with AfterLayoutMixin<AdvertHomepage> {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<ServiceProvider>(context, listen: false).getAllServices();
  }

  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceprovider, _) {
        final service = serviceprovider.serviceModel?.data ?? [];
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu, size: 30),
            ),
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
                    child: CarouselSlider(
                      items: [AdvertSliderCard(), AdvertSliderCard()],
                      options: CarouselOptions(
                        height: 160,
                        viewportFraction: 1,
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
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
                  Text(
                    "Our Services",
                    style: GoogleFonts.poppins(fontSize: 17),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xffFCD7C3).withOpacity(0.30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: serviceprovider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : serviceprovider.error != null
                        ? Center(
                            child: Text(
                              "Error: ${serviceprovider.error}",
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : service.isEmpty
                        ? Center(
                            child: Text(
                              "No services available",
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: service
                                  .map(
                                    (s) => ServiceCard(
                                      ImageUrl: BaseUrl + (s.serviceIcon ?? ""),
                                      serviceTitle: s.serviceTitle,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                  ),

                  SizedBox(height: 50),

                  Text(
                    "Our Major Clients",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      letterSpacing: 1,
                      // color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 90,
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
      },
    );
  }
}
