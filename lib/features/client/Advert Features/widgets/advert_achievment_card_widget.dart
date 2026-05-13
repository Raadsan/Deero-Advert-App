import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/achievement_provider.dart';

class AdvertAchievmentCardWidget extends StatelessWidget {
  const AdvertAchievmentCardWidget({super.key});

  /// ANIMATED NUMBER
  Widget _buildAnimatedNumber(int targetValue, TextStyle style) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: targetValue),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Text("$value+", style: style);
      },
    );
  }

  /// NETWORK IMAGE
  Widget _buildIcon(
    String? iconUrl,
    String fallbackAsset, {
    double width = 35,
    double height = 35,
    BoxFit fit = BoxFit.contain,
  }) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      String fullUrl = iconUrl;

      if (!fullUrl.startsWith("http")) {
        String imagePath = iconUrl.replaceAll("\\", "/");
        fullUrl = "${EndPoint.replaceAll('api/', '')}$imagePath";
      }

      return Image.network(
        fullUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (c, e, s) {
          return Image.asset(
            fallbackAsset,
            width: width,
            height: height,
            fit: fit,
          );
        },
      );
    }

    return Image.asset(fallbackAsset, width: width, height: height, fit: fit);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementProvider>(
      builder: (context, provider, child) {
        /// LOADING
        if (provider.isLoading) {
          return _buildShimmer();
        }

        final achievements = provider.achievementModel?.data ?? [];

        /// SAFE DATA
        String getTitle(int index, String fallback) {
          if (achievements.length > index) {
            return achievements[index].title ?? fallback;
          }
          return fallback;
        }

        int getCount(int index, int fallback) {
          if (achievements.length > index) {
            return achievements[index].count ?? fallback;
          }
          return fallback;
        }

        String? getIcon(int index) {
          if (achievements.length > index) {
            return achievements[index].icon;
          }
          return null;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT SIDE
            Expanded(
              child: Column(
                children: [
                  /// HAPPY CLIENTS
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
                        _buildIcon(
                          getIcon(0),
                          "images/advertimages/happyclients.png",

                          width: 40,
                          height: 40,
                        ),

                        const Spacer(),

                        _buildAnimatedNumber(
                          getCount(0, 3059),

                          GoogleFonts.poppins(
                            fontSize: 22,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5C1B1B),
                          ),
                        ),

                        Text(
                          getTitle(0, "Happy Clients"),

                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            letterSpacing: 1,
                            color: const Color(0xFF5C1B1B),
                          ),

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// PRO TEAM
                  Container(
                    height: 80,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE0D2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFF3A086),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              _buildAnimatedNumber(
                                getCount(1, 11),

                                GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: const Color(0xFF5C1B1B),
                                  height: 1.1,
                                ),
                              ),

                              Text(
                                getTitle(1, "Pro Team"),

                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  letterSpacing: 1,
                                  color: const Color(0xFF5C1B1B),
                                ),

                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        _buildIcon(
                          getIcon(1),
                          "images/advertimages/team.png",

                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            /// RIGHT SIDE
            Expanded(
              child: Column(
                children: [
                  /// COMPLETED PROJECTS
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
                        _buildIcon(
                          getIcon(2),
                          "images/advertimages/completeprojects.png",

                          width: 40,
                          height: 40,
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              _buildAnimatedNumber(
                                getCount(2, 7089),

                                GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),

                              Text(
                                getTitle(2, "Completed Project"),

                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),

                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// AWARDS
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              _buildAnimatedNumber(
                                getCount(3, 9),

                                GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5C1B1B),
                                  height: 1.1,
                                ),
                              ),

                              Text(
                                getTitle(3, "Awards won"),

                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF5C1B1B),
                                ),

                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        _buildIcon(
                          getIcon(3),
                          "images/advertimages/award.png",

                          width: 42,
                          height: 42,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// SHIMMER
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              children: [
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
