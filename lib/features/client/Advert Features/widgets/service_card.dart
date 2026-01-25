import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
          if (ImageUrl != null && ImageUrl!.isNotEmpty)
            SizedBox(
              width: 40,
              height: 40,
              child: ScalableImageWidget.fromSISource(
                si: ScalableImageSource.fromSvgHttpUrl(Uri.parse(ImageUrl!)),
                fit: BoxFit.contain,
              ),
            ),
          SizedBox(height: 5),
          Text(
            serviceTitle ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
