import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvertSliderCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const AdvertSliderCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 25),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Image on the right side
          Positioned(
            right: -10, // Slight overflow to the right
            top: -10,
            bottom: -10,
            child: FadeInRight(
              child: Image.asset(imagePath, width: 155, fit: BoxFit.contain),
            ),
          ),

          // Content Left side
          Row(
            children: [
              Expanded(
                flex: 6,
                child: FadeInLeft(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 4,
                child: SizedBox(), // Empty space for the image to show
              ),
            ],
          ),
        ],
      ),
    );
  }
}
