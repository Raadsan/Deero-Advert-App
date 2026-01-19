import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/news_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/news_model.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/widgets/advert_news_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
              ? Center(child: CircularProgressIndicator())
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

