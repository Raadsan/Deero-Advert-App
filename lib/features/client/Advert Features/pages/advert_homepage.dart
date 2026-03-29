import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/check_domain_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_domains_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/advert_drawer.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/advert_slider_card.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/notification_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:after_layout/after_layout.dart';
import 'package:line_icons/line_icons.dart';
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
  int _currentIndex = 0;

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<ServiceProvider>(context, listen: false).getAllServices();
    Provider.of<HostingProvider>(context, listen: false).getAllHosting();
    Provider.of<NotificationProvider>(
      context,
      listen: false,
    ).activeNotification();
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
            // title:Image.asset(advertfulllogo),
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Image.asset(
                  "images/advertimages/menu.png",
                  // width: 30,
                  // height: 30,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF7B1710),
                          Color(0xFFB52E1D),
                          Color(0xFFE24122),
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CarouselSlider(
                            items: const [
                              AdvertSliderCard(
                                title: "Web Solution",
                                description:
                                    "Professional web solutions including design, hosting, and domain services.",
                                imagePath: "images/advertimages/web.png",
                              ),
                              AdvertSliderCard(
                                title: "Graphic Design",
                                description:
                                    "Stunning graphics that communicate your brand's core values effectively.",
                                imagePath: "images/advertimages/graphic.png",
                              ),
                              AdvertSliderCard(
                                title: "Digital Marketing",
                                description:
                                    "Data-driven marketing strategies to increase brand visibility online.",
                                imagePath: "images/advertimages/marketing.png",
                              ),
                            ],
                            options: CarouselOptions(
                              height: 160,
                              viewportFraction: 1,
                              aspectRatio: 16 / 9,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlayAnimationDuration: const Duration(
                                milliseconds: 800,
                              ),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                        // Indicator dots
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: _currentIndex == index ? 20 : 8,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: _currentIndex == index
                                      ? const Color(
                                          0xFFF3664C,
                                        ) // Active button-like color
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 41,
                    width: double.infinity,
                    child: TextFormField(
                      controller: _domainController,
                      onFieldSubmitted: (_) => _searchDomain(context),
                      decoration: InputDecoration(
                        prefixIcon: Icon(LineIcons.search),
                        hintText: "search your domain",
                        fillColor: Color(0xffEAE8DA).withOpacity(0.30),
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(46),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Our Services",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    // Note: Removed the grey/orange background box to match the clean look of the new mock-up.
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
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.start,
                              children: service
                                  .map(
                                    (s) => ServiceCard(
                                      ImageUrl: s.serviceIcon != null
                                          ? (s.serviceIcon!.startsWith('http')
                                                ? s.serviceIcon!
                                                : BaseUrl +
                                                      "uploads/" +
                                                      s.serviceIcon!)
                                          : "",
                                      serviceTitle: s.serviceTitle,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                  ),

                  SizedBox(height: 35),

                  // Our Portfolio Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Our Portfolio",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "See All",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(
                              0xFFE24122,
                            ), // Matching light orange text
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFA71206,
                      ), // Deep red color identical to the mockup background
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        // Left Side - Text & Button
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                              top: 20,
                              bottom: 20,
                              right: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Graphic Design",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    "We create attractive visual designs including logos, social media posts, flyers, banners, and branding materials that make your business stand out.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.3,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 8),
                                InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFFDF6F4,
                                      ), // Light cream color for the button
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "View project",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: const Color(0xFFA71206),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Right Side - Image
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 12,
                              top: 12,
                              bottom: 12,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.blue.withOpacity(
                                  0.1,
                                ), // Optional placeholder background
                                child: Image.asset(
                                  "images/advertimages/9.png", // Tried 9.png, which usually exists for portfolios. If missing, it will handle it via flutter asset errors, user can adjust filename.
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback if the image doesn't exist
                                    return Container(
                                      color: Colors.grey.shade300,
                                      child: const Center(
                                        child: Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

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
