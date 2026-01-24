import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/check_domain_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AdvertDomainsPage extends StatelessWidget {
  final String searchedDomain;

  const AdvertDomainsPage({super.key, required this.searchedDomain});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckDomainProvider>(
      builder: (context, domainProvider, child) {
        final results = domainProvider.results;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, size: 20),
            ),
            title: Text(
              "Domain Availability",
              style: GoogleFonts.poppins(
                fontSize: 20,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xff111827),
              ),
            ),
          ),
          body: domainProvider.loading
              ? const DomainResultShimmer()
              : domainProvider.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          domainProvider.error!,
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff651313),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Try Another Domain",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : results.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No results found",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Search Results for \"$searchedDomain\"",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff651313),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...results.map(
                        (result) => _DomainCard(
                          domain: result.domain,
                          isAvailable: result.available,
                          price: result.price,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _DomainCard extends StatelessWidget {
  final String domain;
  final bool isAvailable;
  final String price;

  const _DomainCard({
    required this.domain,
    required this.isAvailable,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable
              ? const Color(0xFFE5E7EB)
              : Colors.red.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Domain Info (Left Side)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    domain,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff111827),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isAvailable) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          price.split('/').first,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff111827),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$price.original", // Mocking an original price for visual match
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade400,
                          ),
                        ).buildStruckPrice(price),
                      ],
                    ),
                    Text(
                      "for first year",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xff111827),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Available",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF166534),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      "Not Available",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Cart Button (Right Side)
            if (isAvailable)
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff111827).withOpacity(0.8),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added to cart: $domain"),
                          backgroundColor: const Color(0xff651313),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.add_shopping_cart_outlined,
                      color: Color(0xff111827),
                      size: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension on Widget {
  Widget buildStruckPrice(String currentPrice) {
    // This is a helper to generate a visual struck-through price for the "Wow" factor
    // calculated as roughly 4x the current price to match the registrar feel
    try {
      double p = double.parse(currentPrice.replaceAll(RegExp(r'[^0-9.]'), ''));
      String original = (p * 4.5).toStringAsFixed(2);
      return Text(
        "\$$original",
        style: GoogleFonts.poppins(
          fontSize: 16,
          decoration: TextDecoration.lineThrough,
          color: Colors.grey.shade400,
        ),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}

class DomainResultShimmer extends StatelessWidget {
  const DomainResultShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 20,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Main domain card shimmer
          ...List.generate(
            5,
            (index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 12,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 32,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
