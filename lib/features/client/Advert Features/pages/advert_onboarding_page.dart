import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconly/iconly.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_navigationpage.dart';

class AdvertOnboardingPage extends StatefulWidget {
  const AdvertOnboardingPage({super.key});

  @override
  State<AdvertOnboardingPage> createState() => _AdvertOnboardingPageState();
}

class _AdvertOnboardingPageState extends State<AdvertOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Elevate Your Brand",
      subtitle: "Marketing & Strategy",
      description: "Grow your business with our cutting-edge advertising solutions tailored for success.",
      lottieUrl: "https://lottie.host/80a221f7-e43e-4b71-b46c-e0921473950d/bYgYmP4A9o.json",
      colors: [const Color(0xFF651313), const Color(0xFF9B1A1A)],
    ),
    OnboardingData(
      title: "Social Media Mastery",
      subtitle: "Creative Management",
      description: "Connect with your audience through engaging content and strategic media placement.",
      lottieUrl: "https://lottie.host/88031590-3376-4cc2-98b7-60e58849b380/v6T0z0q0mQ.json",
      colors: [const Color(0xFFEB4724), const Color(0xFFF37559)],
    ),
    OnboardingData(
      title: "Instant Growth",
      subtitle: "Support & Results",
      description: "Our mission is to ensure your business reaches its full potential in the digital world.",
      lottieUrl: "https://lottie.host/195b0f5c-4a3e-4e4c-8f92-75d19a4a7f0e/gQ5m6O2R6a.json",
      colors: [const Color(0xFF111827), const Color(0xFF374151)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdvertNavigationpage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Advanced Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _pages[_currentPage].colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🔹 Decorative Background Elements (Blured Circles)
          Positioned(
            top: -50,
            left: -50,
            child: FadeInDown(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -100,
            child: FadeInUp(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // 🔹 Top Overlay Tools
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeInLeft(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Text(
                        "Deero Premium",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  FadeInRight(
                    child: TextButton(
                      onPressed: _navigateToHome,
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Page Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                _startTimer(); // Restart timer on manual swipe
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingItemContent(data: _pages[index]);
            },
          ),

          // 🔹 Bottom Navigation Controls (Row with Icons)
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Real-time Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: _currentPage == index ? 24 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 🔹 Dynamic Action Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button (Hidden on first page)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _currentPage == 0 ? 0.0 : 1.0,
                      child: GestureDetector(
                        onTap: _currentPage == 0
                            ? null
                            : () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Icon(IconlyLight.arrow_left_2, color: Colors.white, size: 24),
                        ),
                      ),
                    ),

                    // Main Center Button / Continue
                    if (_currentPage == _pages.length - 1)
                      FadeInScale(
                        child: ElevatedButton(
                          onPressed: _navigateToHome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _pages[_currentPage].colors[0],
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                          ),
                          child: Text(
                            "Get Started",
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                    // Next Button
                    GestureDetector(
                      onTap: () {
                        if (_currentPage == _pages.length - 1) {
                          _navigateToHome();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          _currentPage == _pages.length - 1 ? IconlyBold.tick_square : IconlyLight.arrow_right_2,
                          color: _pages[_currentPage].colors[0],
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItemContent extends StatelessWidget {
  final OnboardingData data;
  const OnboardingItemContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔹 ANIMATED LOTTIE
          FadeInDown(
            duration: const Duration(milliseconds: 1000),
            child: Container(
              height: 320,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Lottie.network(
                data.lottieUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.stars_rounded, size: 120, color: Colors.white);
                },
              ),
            ),
          ),
          const SizedBox(height: 40),

          // 🔹 SUBTITLE LABEL
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                data.subtitle.toUpperCase(),
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 🔹 MAIN TITLE
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 DESCRIPTION
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
          ),

          const SizedBox(height: 100), // Space for bottom controls
        ],
      ),
    );
  }
}

class FadeInScale extends StatelessWidget {
  final Widget child;
  const FadeInScale({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 600),
      child: ZoomIn(
        duration: const Duration(milliseconds: 600),
        child: child,
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String lottieUrl;
  final List<Color> colors;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.lottieUrl,
    required this.colors,
  });
}
