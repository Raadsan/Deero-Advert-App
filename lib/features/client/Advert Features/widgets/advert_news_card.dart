import 'package:deero_enterprise_app/features/client/Advert%20Features/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsCard extends StatelessWidget {
  final Data newsItem;

  const NewsCard({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Future navigation to detail page
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff660E0D).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        newsItem.type?.toUpperCase() ?? "NEWS",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff660E0D),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  newsItem.title ?? "No Title",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium weight, NOT bold
                    color: const Color(0xff1f2937),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Color(0xffE5E7EB),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _timeAgo(newsItem.date),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return "";
    }
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return "Just now";
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return _formatDate(dateStr);
      } else if (difference.inDays >= 1) {
        return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
      } else if (difference.inHours >= 1) {
        return "${difference.inHours} ${difference.inHours == 1 ? 'h' : 'h'} ago";
      } else if (difference.inMinutes >= 1) {
        return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'm' : 'm'} ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return "Just now";
    }
  }
}
