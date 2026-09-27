import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Discount / offer homepage banner.
/// Background shape (incl. bottom notch) comes from [images/offerbg.png].
class AdvertDiscountBannerCard extends StatelessWidget {
  /// e.g. "35% OFF" or "35% Off"
  final String offerTitle;

  /// Line under the big offer (service name or promo line).
  final String serviceName;

  final String imagePath;
  final bool isNetworkImage;
  final VoidCallback? onTap;

  /// Small top pill label.
  final String limitedLabel;

  /// Bottom CTA button label.
  final String ctaText;

  /// Pill + CTA red accent.
  final Color accentColor;

  static const String bgAsset = "images/offerbg.png";

  const AdvertDiscountBannerCard({
    super.key,
    required this.offerTitle,
    required this.serviceName,
    this.imagePath = "",
    this.isNetworkImage = false,
    this.onTap,
    this.limitedLabel = "Limited Offer",
    this.ctaText = "Get The Offer Now",
    this.accentColor = const Color(0xFFE31C23),
  });

  /// "35% OFF" → "35% Off" for display.
  String get _displayOffer {
    final t = offerTitle.trim();
    if (t.toUpperCase().endsWith(" OFF")) {
      final head = t.substring(0, t.length - 4).trimRight();
      return "$head Off";
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 600;
        final h = constraints.maxHeight;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: h.isFinite ? h : null,
              padding: EdgeInsets.fromLTRB(
                wide ? 28 : 20,
                wide ? 16 : 12,
                wide ? 28 : 20,
                wide ? 28 : 24, // extra bottom for notch in offerbg.png
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgAsset),
                  fit: BoxFit.fill,
                ),
              ),
              child: FadeInLeft(
                duration: const Duration(milliseconds: 450),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              serviceName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: wide ? 16 : 14,
                                color: Colors.white.withOpacity(0.92),
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: wide ? 8 : 6),
                            Text(
                              _displayOffer,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: GoogleFonts.montserrat(
                                fontSize: wide ? 40 : 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: wide ? 10 : 8),
                            if (ctaText.isNotEmpty)
                              Material(
                                color: Color(0xffec4724),
                                borderRadius: BorderRadius.circular(50),
                                child: InkWell(
                                  onTap: onTap,
                                  borderRadius: BorderRadius.circular(50),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: wide ? 18 : 14,
                                      vertical: wide ? 10 : 8,
                                    ),
                                    child: Text(
                                      ctaText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        fontSize: wide ? 14 : 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "images/offer.png",
                        width: wide ? 110 : 100,
                        height: wide ? 110 : 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
