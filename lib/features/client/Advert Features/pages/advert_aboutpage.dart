import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/core/themes/color_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/testimonial_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdvertAboutpage extends StatefulWidget {
  const AdvertAboutpage({super.key});

  @override
  State<AdvertAboutpage> createState() => _AdvertAboutpageState();
}

class _AdvertAboutpageState extends State<AdvertAboutpage>
    with AfterLayoutMixin<AdvertAboutpage> {
  int _expandedIndex = 0; // 0 for Vision, 1 for Mission, 2 for Core Values

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Provider.of<TestimonialProvider>(context, listen: false).getTestimonials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 🔹 Advanced Sliver App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            stretch: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(
                    IconlyLight.arrow_left_2,
                    color: Color(0xff651210),
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            backgroundColor: const Color(0xff651210),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "images/advertimages/about.png",
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xff651210).withOpacity(0.7),
                          const Color(0xff651210),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffEF7044),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "SINCE 2019",
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Deero Advertising\nAgency",
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Main Content Section
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      "WHO WE ARE",
                      "Pioneering Digital Excellence",
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          "Deero Advertising Agency is one of the most innovative digital service providers in Somalia. Founded in 2019, we've revolutionized how businesses connect with their audience through top-tier design, marketing, and technology solutions.",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            height: 1.8,
                            color: const Color(0xff4B5563),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 🔹 Vision, Mission & Core Values Accordion (As requested)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xffE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Color(0xff4CAF50),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Vision and Mission",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff1f2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildAccordionItem(
                            index: 0,
                            title: "Vision",
                            icon:
                                Icons.biotech_outlined, // Binoculars-like icon
                            content:
                                "To provide quality, innovative & high-value service to customers locally and worldwide.",
                          ),
                          _buildAccordionItem(
                            index: 1,
                            title: "Mission",
                            icon: Icons.terrain_outlined, // Mountain-like icon
                            content:
                                "To provide quality services that exceed the expectations of our esteemed customers.",
                          ),
                          _buildAccordionItem(
                            index: 2,
                            title: "Core Values",
                            icon: Icons.eco_outlined, // Plant/Hands icon
                            content:
                                "Innovation & Excellence, Client Care, Collaboration, Social Responsibility, and Honest & Integrity.",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 45),
                    _buildSectionHeader("OUR ACHIEVEMENTS", "By the numbers"),
                    const SizedBox(height: 20),
                    _buildStatsGrid(),

                    const SizedBox(height: 50),

                    _buildSectionHeader("TESTIMONIALS", "What our clients say"),
                    const SizedBox(height: 20),
                    _buildTestimonialsSection(),

                    const SizedBox(height: 50),

                    // --- FOOTER / CTA ---
                    FadeIn(
                      delay: const Duration(milliseconds: 500),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff651210), Color(0xff430C0B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              IconlyBold.message,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Ready to start your journey?",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Let's work together to make your brand stand out.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 25),
                            ElevatedButton(
                              onPressed: () async {
                                final uri = Uri.parse(kAdvertSocialWhatsAppUrl);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffEF7044),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Contact Us Now",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionItem({
    required int index,
    required String title,
    required IconData icon,
    required String content,
  }) {
    bool isExpanded = _expandedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _expandedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isExpanded ? const Color(0xff651210) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isExpanded ? Colors.white : const Color(0xff3F51B5),
                    size: 28,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isExpanded
                          ? Colors.white
                          : const Color(0xff1f2937),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isExpanded ? Colors.white : Colors.grey,
                  ),
                ],
              ),
            ),
            if (isExpanded)
              FadeIn(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.6,
                      color: const Color(0xff4B5563),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper: Section Header
  Widget _buildSectionHeader(String subtitle, String title) {
    return FadeInLeft(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(height: 1, width: 30, color: const Color(0xffEF7044)),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: const Color(0xffEF7044),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xff111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          child: Column(
            children: [
              _buildAchieveCard(
                value: "3,059+",
                label: "Happy Clients",
                imagePath: "images/advertimages/happyclients.png",
                bgColor: const Color(0xFFFFF5EE),
                textColor: const Color(0xFF651210),
                height: 180,
                isTopLeft: true,
              ),
              const SizedBox(height: 12),
              _buildAchieveCard(
                value: "11+",
                label: "Pro Team",
                imagePath: "images/advertimages/team.png",
                bgColor: const Color(0xFFFFE0CC),
                textColor: const Color(0xFF651210),
                height: 130,
                isBottomLeft: true,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Right Column
        Expanded(
          child: Column(
            children: [
              _buildAchieveCard(
                value: "7,089+",
                label: "Completed Project",
                imagePath: "images/advertimages/completeprojects.png",
                bgColor: const Color(0xFFEF7044),
                textColor: Colors.white,
                height: 130,
                isTopRight: true,
              ),
              const SizedBox(height: 12),
              _buildAchieveCard(
                value: "9+",
                label: "Awards won",
                imagePath: "images/advertimages/award.png",
                bgColor: const Color(0xFFFFF5EE),
                textColor: const Color(0xFF651210),
                height: 180,
                isBottomRight: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchieveCard({
    required String value,
    required String label,
    required String imagePath,
    required Color bgColor,
    required Color textColor,
    required double height,
    bool isTopLeft = false,
    bool isBottomLeft = false,
    bool isTopRight = false,
    bool isBottomRight = false,
  }) {
    bool isSolid = bgColor == const Color(0xFFEF7044);
    Color imageColor = isSolid ? Colors.white : const Color(0xFFEF7044);

    return FadeInUp(
      child: Container(
        height: height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: isSolid
              ? null
              : Border.all(
                  color: const Color(0xFFEF7044).withOpacity(0.3),
                  width: 1,
                ),
        ),
        child: isTopLeft
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(imagePath, height: 40, color: imageColor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textColor.withOpacity(0.9),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              )
            : isBottomLeft
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: textColor.withOpacity(0.9),
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(imagePath, height: 35, color: imageColor),
                ],
              )
            : isTopRight
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(imagePath, height: 35, color: imageColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: textColor.withOpacity(0.9),
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Space at top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              label,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: textColor.withOpacity(0.9),
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(imagePath, height: 35, color: imageColor),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Consumer<TestimonialProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffEF7044)),
          );
        }

        if (provider.error.isNotEmpty) {
          return Center(
            child: Text(
              provider.error,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final testimonials = provider.testimonialModel?.testimonials ?? [];
        if (testimonials.isEmpty) {
          return Center(
            child: Text(
              "No testimonials found.",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          );
        }

        return CarouselSlider(
          items: testimonials.map((testimonial) {
            final imageUrl = testimonial.clientImage != null
                ? (testimonial.clientImage!.startsWith('http')
                      ? testimonial.clientImage!
                      : BaseUrl + "uploads/" + testimonial.clientImage!)
                : "";

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    color: Color(0xffEF7044),
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      testimonial.message ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : null,
                        child: imageUrl.isEmpty
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              testimonial.clientName ?? "Unknown Client",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              testimonial.clientTitle ?? "Client",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xffEF7044),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 250,
            viewportFraction: 0.9,
            enableInfiniteScroll: testimonials.length > 1,
            autoPlay: testimonials.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
          ),
        );
      },
    );
  }
}
