import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/careers_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/advert_career_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

class AdvertCareerPage extends StatefulWidget {
  const AdvertCareerPage({super.key});

  @override
  State<AdvertCareerPage> createState() => _AdvertCareerPageState();
}

class _AdvertCareerPageState extends State<AdvertCareerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CareersProvider>();
      provider.getAllCareers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CareersProvider>(
      builder: (context, careersProvider, child) {
        final careersList = careersProvider.careersModel?.data ?? [];
        return Scaffold(
          backgroundColor: const Color(0xffF9FAFB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Color(0xff660E0D),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Join Our Team",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xff660E0D),
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  context.read<CareersProvider>().getAllCareers();
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xff660E0D),
                ),
              ),
            ],
          ),
          body: careersProvider.isLoading
              ? const CareerListShimmer()
              : careersList.isEmpty
              ? const Center(child: Text("No careers found"))
              : careersProvider.error != null
              ? Center(child: Text(careersProvider.error!))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: careersList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final careerItem = careersList[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 200 + (index * 200)),
                      curve: Curves.bounceIn,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(100 * (1 - value), 0),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: CareerCard(careerItem: careerItem),
                    );
                  },
                ),
        );
      },
    );
  }
}

class CareerListShimmer extends StatelessWidget {
  const CareerListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.08)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Type tag and Status tag)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Title (2 lines)
                Container(
                  height: 18,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 18,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),

                // Location Row
                Row(
                  children: [
                    Container(
                      height: 14,
                      width: 14,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 14,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Divider
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.white,
                ),

                const SizedBox(height: 14),

                // Footer (Date and CTA)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Row(
                      children: [
                        Container(
                          height: 14,
                          width: 14,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    // CTA
                    Container(
                      height: 14,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
