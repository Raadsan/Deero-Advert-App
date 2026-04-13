import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvertAboutpage extends StatelessWidget {
  const AdvertAboutpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF8F5), // Light cream background
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: FadeInDown(
          child: Text(
            "About Deero",
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: const Color(0xff651210),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(painter: GridPatternPainter()),
            ),
          ),

          // Decorative Blobs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xff651313).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: const Color(0xff651313).withOpacity(0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image with Shadow
                  FadeIn(
                    duration: const Duration(seconds: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff651313).withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "images/advertimages/about.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Text Card
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "WHO WE ARE",
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.8,
                            color: const Color(0xff651313).withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xff651313).withOpacity(0.08),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xff651313,
                                ).withOpacity(0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                            child: Text(
                              "Deero Advertising Agency is one of the innovative digital service providers in Somalia, founded in 2019 to offer a wide range of digital creative services. Deero Advert is the first advertising company that provides a wide variety of one-stop digital creative services in Somalia.",
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                height: 1.7,
                                letterSpacing: 0.15,
                                color: const Color(0xff1f2937),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Vision & Mission Section
                  Text(
                    "VISION & MISSION",
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8,
                      color: const Color(0xff651313).withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          title: "Vision",
                          icon: Icons.visibility_outlined,
                          description:
                              "To provide quality, innovative & high-value service to customers locally and worldwide.",
                          delay: 400,
                          color: const Color(0xff651313),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          title: "Mission",
                          icon: Icons.auto_awesome_outlined,
                          description:
                              "To provide quality services that exceed the expectations of our esteemed customers.",
                          delay: 600,
                          color: const Color(0xff7a1c1c),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Core Values Section
                  Center(
                    child: FadeInUp(
                      child: Column(
                        children: [
                          Text(
                            "OUR CORE VALUES",
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.8,
                              color: const Color(0xff651313).withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "What drives us",
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff111827),
                              letterSpacing: -0.3,
                            ),
                          ),
                          Container(
                            height: 3,
                            width: 48,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xff651313),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  _buildCoreValueItem(
                    title: "Innovation & Excellence",
                    icon: Icons.lightbulb_outline,
                    delay: 800,
                  ),
                  _buildCoreValueItem(
                    title: "Client Care",
                    icon: Icons.favorite_outline,
                    delay: 1000,
                  ),
                  _buildCoreValueItem(
                    title: "Collaboration",
                    icon: Icons.groups_outlined,
                    delay: 1200,
                  ),
                  _buildCoreValueItem(
                    title: "Social Responsibility",
                    icon: Icons.public,
                    delay: 1400,
                  ),
                  _buildCoreValueItem(
                    title: "Honest & Integrity",
                    icon: Icons.verified_user_outlined,
                    delay: 1600,
                  ),
                  const SizedBox(height: 36),
                  Text(
                    "OUR ACHIEVEMENTS",
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8,
                      color: const Color(0xff651313).withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "By the numbers",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff111827),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String description,
    required int delay,
    required Color color,
  }) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: Container(
        constraints: const BoxConstraints(minHeight: 252),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -24,
              child: Opacity(
                opacity: 0.12,
                child: Icon(icon, size: 110, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.92),
                      height: 1.55,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoreValueItem({
    required String title,
    required IconData icon,
    required int delay,
  }) {
    return FadeInLeft(
      delay: Duration(milliseconds: delay),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xff651313).withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff651313).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xff651313), size: 24),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xff111827),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xff651313).withOpacity(0.2),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff651313)
      ..strokeWidth = 1;

    const spacing = 30.0;
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
