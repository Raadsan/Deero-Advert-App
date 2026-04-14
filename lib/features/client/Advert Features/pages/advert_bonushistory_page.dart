import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:shimmer/shimmer.dart';

class AdvertBonusHistoryPage extends StatefulWidget {
  const AdvertBonusHistoryPage({super.key});

  @override
  State<AdvertBonusHistoryPage> createState() => _AdvertBonusHistoryPageState();
}

class _AdvertBonusHistoryPageState extends State<AdvertBonusHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getBonusHistoryLocal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "Bonus History",
          style: GoogleFonts.poppins(
            color: const Color(0xff660E0D),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Color(0xff660E0D),
          ),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isHistoryLoading) {
            return _buildShimmer(context);
          }

          if (userProvider.bonusHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xffFCD9CC).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(IconlyLight.star, size: 60, color: Color(0xFFEB4724)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "No Bonus Yet",
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Start purchasing services to earn bonus points!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: userProvider.bonusHistory.length,
            itemBuilder: (context, index) {
              final history = userProvider.bonusHistory[index];
              final isAdd = history.type == 'add';
              final date = history.createdAt != null
                  ? DateTime.parse(history.createdAt!)
                  : DateTime.now();
              final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAdd
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isAdd ? IconlyLight.arrow_up_2 : IconlyLight.arrow_down_2,
                        color: isAdd ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            history.reason ?? "Bonus Transaction",
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${isAdd ? '+' : ''}${history.amount}",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isAdd ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}
