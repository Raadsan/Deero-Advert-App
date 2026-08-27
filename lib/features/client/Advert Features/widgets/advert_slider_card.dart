import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class AdvertSliderCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isNetworkImage;
  final bool isOffer;
  final VoidCallback? onTap;

  const AdvertSliderCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.isNetworkImage = false,
    this.isOffer = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidth = isOffer ? 110.0 : 155.0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 25),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: isOffer ? 4 : -10,
              top: isOffer ? 8 : -10,
              bottom: isOffer ? 18 : -10,
              child: FadeInRight(
                child: SizedBox(
                  width: imageWidth,
                  child: isNetworkImage && imagePath.isNotEmpty
                      ? Image.network(
                          imagePath,
                          width: imageWidth,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Colors.white24,
                              highlightColor: Colors.white54,
                              child: Container(
                                width: imageWidth * 0.75,
                                height: imageWidth * 0.75,
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Image.asset(
                            "images/advertimages/web.png",
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          width: imageWidth,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: isOffer ? 7 : 6,
                  child: FadeInLeft(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: isOffer
                              ? GoogleFonts.pacifico(
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  height: 1.15,
                                )
                              : GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  height: 1.05,
                                ),
                          maxLines: isOffer ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: isOffer ? 13 : 11,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight:
                                isOffer ? FontWeight.w500 : FontWeight.w400,
                            height: isOffer ? 1.4 : 1.35,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: isOffer ? 3 : 4,
                  child: const SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton shown while homepage slider data is loading.
class AdvertSliderShimmer extends StatelessWidget {
  const AdvertSliderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 160,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5C0F0C),
              Color(0xFFB52E1D),
              Color(0xFFE24122),
              Color(0xFFF3664C),
            ],
            stops: [0.0, 0.38, 0.72, 1.0],
          ),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.18),
          highlightColor: Colors.white.withOpacity(0.42),
          period: const Duration(milliseconds: 1200),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 16, 20),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 36,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 12,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 12,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 5,
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
          ),
        ),
      ),
    );
  }
}
