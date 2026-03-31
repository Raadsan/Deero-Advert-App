import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/check_domain_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/hosting_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/portfolio_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_notificationpage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_portfoliopage.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_project_details.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_domains_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_servicepage.dart';
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
    Provider.of<PortfolioProvider>(context, listen: false).getPortfolio();
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

  Widget build(BuildContext context) {
    return Consumer2<ServiceProvider, PortfolioProvider>(
      builder: (context, serviceprovider, portfolioProvider, _) {
        final service = serviceprovider.serviceModel?.data ?? [];
        return Scaffold(
          backgroundColor: Colors.white,
          drawer: const AdvertDrawer(),

          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarContrastEnforced: true,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdvertNotificationpage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Color(0xff660E0D),
                ),
              ),
            ],
            title: Image.asset(fullAdvertLogo, width: 120),
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
                              children: service.asMap().entries.map((entry) {
                                int index = entry.key;
                                var s = entry.value;
                                return ServiceCard(
                                  ImageUrl: s.serviceIcon != null
                                      ? (s.serviceIcon!.startsWith('http')
                                            ? s.serviceIcon!
                                            : BaseUrl +
                                                  "uploads/" +
                                                  s.serviceIcon!)
                                      : "",
                                  serviceTitle: s.serviceTitle,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdvertServicepage(
                                          initialIndex: index,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                  ),

                  SizedBox(height: 15),

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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdvertPortfoliopage(),
                            ),
                          );
                        },
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
                  const SizedBox(height: 10),
                  portfolioProvider.isLoading
                      ? Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.only(
                            left: 18,
                            top: 20,
                            bottom: 20,
                            right: 8,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: double.infinity,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        height: 10,
                                        width: double.infinity,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        height: 10,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.4,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        height: 10,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.2,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : portfolioProvider.error.isNotEmpty
                      ? Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "Error: ${portfolioProvider.error}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      : (portfolioProvider
                                .portfolioModel
                                ?.portfolios
                                ?.isEmpty ??
                            true)
                      ? Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "No portfolio projects yet",
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          ),
                        )
                      : CarouselSlider(
                          items: (portfolioProvider.portfolioModel?.portfolios ?? []).map((
                            project,
                          ) {
                            final imageUrl = project.mainImage != null
                                ? (project.mainImage!.startsWith('http')
                                      ? project.mainImage!
                                      : BaseUrl + project.mainImage!)
                                : "";

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdvertProjectDetailsPage(
                                          project: project,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Colors
                                      .grey
                                      .shade900, // Keeps text readable while the image is loading
                                  image: DecorationImage(
                                    image: imageUrl.isNotEmpty
                                        ? NetworkImage(imageUrl)
                                              as ImageProvider
                                        : const AssetImage(
                                            "images/advertimages/1.png",
                                          ),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.45),
                                      BlendMode.darken,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18,
                                          top: 20,
                                          bottom: 20,
                                          right: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              project.title ?? "Graphic Design",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: Text(
                                                project.description ??
                                                    "We create attractive visual designs including logos, social media posts, flyers, banners, and branding materials that make your business stand out.",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  height: 1.3,
                                                ),
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Empty space on the right side to let the background image shine through
                                    Expanded(
                                      flex: 4,
                                      child: const SizedBox(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 140,
                            viewportFraction: 1.0,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            enlargeCenterPage: false,
                          ),
                        ),

                  SizedBox(height: 40),

                  Text(
                    "Our Major Clients",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      letterSpacing: 1,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: CarouselSlider(
                      items:
                          [
                            "images/advertimages/2.png",
                            "images/advertimages/3.png",
                            "images/advertimages/4.png",
                            "images/advertimages/5.png",
                            "images/advertimages/6.png",
                          ].map((imagePath) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFFF3664C,
                                  ).withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                      options: CarouselOptions(
                        height: 80,
                        viewportFraction: 0.25,
                        autoPlay: true,
                        scrollDirection: Axis.horizontal,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: false,
                        scrollPhysics: const BouncingScrollPhysics(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  Text(
                    "Our Achievements",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      letterSpacing: 1,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          children: [
                            // 3,059+ Happy Clients Card
                            Container(
                              height: 130,
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF6F0),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFF3D0C3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "images/advertimages/happyclients.png",
                                  ),
                                  const Spacer(),
                                  Text(
                                    "3,059+",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF5C1B1B),
                                    ),
                                  ),
                                  Text(
                                    "Happy Clients",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      color: const Color(0xFF5C1B1B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // 11+ Pro Team Card
                            Container(
                              height: 80,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE0D2), // Light orange
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(
                                    0xFFF3A086,
                                  ), // Darker orange border
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "11+",
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                          color: const Color(0xFF5C1B1B),
                                          height: 1.1,
                                        ),
                                      ),
                                      Text(
                                        "Pro Team",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          color: const Color(0xFF5C1B1B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Image.asset("images/advertimages/team.png"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Right Column
                      Expanded(
                        child: Column(
                          children: [
                            // 7,089+ Completed Project Card
                            Container(
                              height: 80,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffEF7044),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/advertimages/completeprojects.png",
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "7,089+",
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: Colors.white,
                                            height: 1.1,
                                          ),
                                        ),
                                        Text(
                                          "Completed Project",
                                          style: GoogleFonts.poppins(
                                            fontSize: 9,
                                            letterSpacing: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // 9+ Awards won Card
                            Container(
                              height: 130,
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF6F0),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFF3D0C3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "9+",
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF5C1B1B),
                                          height: 1.1,
                                        ),
                                      ),
                                      Text(
                                        "Awards won",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: const Color(0xFF5C1B1B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Image.asset("images/advertimages/award.png"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
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
