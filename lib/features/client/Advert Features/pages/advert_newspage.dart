import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/news_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/advert_news_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

class AdvertNewspage extends StatefulWidget {
  const AdvertNewspage({super.key});

  @override
  State<AdvertNewspage> createState() => _AdvertNewspageState();
}

class _AdvertNewspageState extends State<AdvertNewspage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NewsProvider>();
      provider.getAllNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        final newsList = newsProvider.newsModel?.data ?? [];
        if(newsProvider.isLoading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(newsProvider.error != null){
          return Center(
            child: Text(newsProvider.error!),
          );
        }
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
              "Latest Updates",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500, // Lighter weight as requested
                color: const Color(0xff660E0D),
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  context.read<NewsProvider>().getAllNews();
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xff660E0D),
                ),
              ),
            ],
          ),
          body: newsProvider.isLoading
              ? const NewsListShimmer()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: newsList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final newsItem = newsList[index];
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
                      child: NewsCard(newsItem: newsItem),
                    );
                  },
                ),
        );
      },
    );
  }
}

class NewsListShimmer extends StatelessWidget {
  const NewsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: 6, // Shimmer items count
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag
                Container(
                  height: 24,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                // Title (2 lines to mimic maxLines: 2)
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                // Divider
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                // Footer (Time)
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
                      width: 100,
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
