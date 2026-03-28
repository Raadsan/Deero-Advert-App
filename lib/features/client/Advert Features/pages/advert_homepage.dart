import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/check_domain_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_domains_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/advert_drawer.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/advert_slider_card.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:after_layout/after_layout.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertHomepage extends StatefulWidget {
  const AdvertHomepage({super.key});

  @override
  State<AdvertHomepage> createState() => _AdvertHomepageState();
}

class _AdvertHomepageState extends State<AdvertHomepage>
    with AfterLayoutMixin<AdvertHomepage> {
  final TextEditingController _domainController = TextEditingController();

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<ServiceProvider>(context, listen: false).getAllServices();
    Provider.of<HostingProvider>(context, listen: false).getAllHosting();
  }

  void _searchDomain(BuildContext context) {
    final domainName = _domainController.text.trim();

    // Check if domain name is empty
    if (domainName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a domain name",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFFEB4724),
        ),
      );
      return;
    }

    // Check if domain has a TLD (like .com, .org, .so, etc.)
    if (!domainName.contains('.') || domainName.endsWith('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please include domain extension (e.g., .com, .org, .so)",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFFEB4724),
        ),
      );
      return;
    }

    // Validate TLD format
    final parts = domainName.split('.');
    if (parts.length < 2 || parts.last.isEmpty || parts.last.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a valid domain with extension (e.g., mywebsite.com)",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFFEB4724),
        ),
      );
      return;
    }

    final domainProvider = Provider.of<CheckDomainProvider>(
      context,
      listen: false,
    );
    domainProvider.checkDomain(domainName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertDomainsPage(searchedDomain: domainName),
      ),
    );
  }

  void _launchWhatsApp() async {
    const String whatsappNumber = "252615930944";
    final String url =
        "https://wa.me/$whatsappNumber?text=Hello Deero Advert, I'm interested in your services.";

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ma suurtagelin in la furo WhatsApp")),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceprovider, _) {
        final service = serviceprovider.serviceModel?.data ?? [];
        return Scaffold(
          backgroundColor: Colors.white,
          drawer: const AdvertDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: _launchWhatsApp,
            child: Image.asset("images/advertimages/whatsapp.png"),
          ),
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarContrastEnforced: true,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu, size: 30),
              ),
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
                                  controller: _domainController,
                                  onFieldSubmitted: (_) =>
                                      _searchDomain(context),
                                  decoration: InputDecoration(
                                    hintText: "e.g. mywebsite.com",
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
                                onPressed: () => _searchDomain(context),
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
                      color: serviceprovider.isLoading
                          ? Colors.white
                          : Color(0xffFCD7C3).withOpacity(0.30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: serviceprovider.isLoading
                        ? const Center(child: ServiceCardShimmer())
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
                                      ImageUrl: s.serviceIcon != null
                                          ? (s.serviceIcon!.startsWith('http')
                                              ? s.serviceIcon!
                                              : BaseUrl + "uploads/" + s.serviceIcon!)
                                          : "",
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

class ServiceCardShimmer extends StatelessWidget {
  final int itemCount;

  const ServiceCardShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(itemCount, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: (MediaQuery.of(context).size.width - 50) / 3,
            child: SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(height: 12, width: 60, color: Colors.grey.shade300),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
