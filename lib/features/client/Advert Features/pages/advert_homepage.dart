import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                  Text(
                    "Our Services",
                    style: GoogleFonts.poppins(fontSize: 17),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xffDFD7D0).withOpacity(0.25),
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
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, this.serviceTitle, this.ImageUrl});
  final String? serviceTitle;
  final String? ImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 50) / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(
            ImageUrl??"",
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 5),
          Text(
            serviceTitle ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
