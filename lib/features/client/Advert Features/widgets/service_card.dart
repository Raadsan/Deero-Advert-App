import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, this.serviceTitle, this.ImageUrl});
  final String? serviceTitle;
  final String? ImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 50) / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            SizedBox(
              width: 44,
              height: 44,
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
                            width: 44,
                            height: 44,
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
          const SizedBox(height: 8),
          Text(
            serviceTitle ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xff4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
