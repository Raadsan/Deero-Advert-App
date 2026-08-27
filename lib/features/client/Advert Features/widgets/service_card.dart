import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    this.serviceTitle,
    this.ImageUrl,
    this.onTap,
    this.discountLabel,
  });
  final String? serviceTitle;
  final String? ImageUrl;
  final VoidCallback? onTap;
  final String? discountLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          (MediaQuery.of(context).size.width - 55) /
          3, // Leave room for padding & spacing
      decoration: BoxDecoration(
        color: const Color(0xffFCD7C3).withOpacity(0.30),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(
            0xFFE24122,
          ).withOpacity(0.25), // Very light orange border
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: (ImageUrl != null && ImageUrl!.isNotEmpty)
                          ? Image.network(
                              ImageUrl!,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade200,
                                  highlightColor: Colors.grey.shade50,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                size: 24,
                                color: Colors.grey.shade400,
                              ),
                            )
                          : Icon(
                              Icons.image_not_supported_outlined,
                              size: 24,
                              color: Colors.grey.shade300,
                            ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      serviceTitle ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff5D6574),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (discountLabel != null && discountLabel!.isNotEmpty)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      discountLabel!,
                      style: GoogleFonts.poppins(
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
