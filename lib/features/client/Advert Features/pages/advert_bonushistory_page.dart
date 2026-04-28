import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:deero_advert_app/features/auth/models/user_model.dart';

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

          final currentBonus = userProvider.userModel?.user?.bonus ?? 0;

          Widget content;
          if (userProvider.bonusHistory.isEmpty) {
            content = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xffFCD9CC).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      IconlyLight.star,
                      size: 60,
                      color: Color(0xFFEB4724),
                    ),
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
          } else {
            List<List<BonusHistory>> cycles = [];
            List<BonusHistory> currentCycle = [];
            int currentSum = 0;

            for (int i = userProvider.bonusHistory.length - 1; i >= 0; i--) {
              final history = userProvider.bonusHistory[i];
              // Insert so newest items stay at the top of the cycle
              currentCycle.insert(0, history);

              if (history.type == 'add') {
                currentSum += (history.amount ?? 0).abs();
              }

              // When accumulated points hit 100, we wrap them as a completed cycle
              if (currentSum >= 100) {
                cycles.insert(0, currentCycle);
                currentCycle = [];
                currentSum = 0;
              }
            }
            // Leftovers that haven't reached 100 yet form the active in-progress cycle
            if (currentCycle.isNotEmpty) {
              cycles.insert(0, currentCycle);
            }

            content = ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: cycles.length,
              itemBuilder: (context, cycleIndex) {
                final cycleItems = cycles[cycleIndex];

                // Calculate total 'add' points inside this specific cycle group
                int cycleSum = 0;
                for (var h in cycleItems) {
                  if (h.type == 'add') {
                    cycleSum += (h.amount ?? 0).abs();
                  }
                }

                // If cycleSum is 100 or more, it's a closed milestone!
                bool isCompleted = cycleSum >= 100;
                bool isCurrentActiveCycle = cycleIndex == 0 && !isCompleted;

                // Sync the true remainder to the active tile!
                int displaySum = cycleSum;
                if (isCurrentActiveCycle) {
                  displaySum = userProvider.userModel?.user?.bonus ?? 0;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: isCurrentActiveCycle,
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      // Expand/Collapse icon styling handled by default flutter icons,
                      // but we can configure leading icon beautiful!
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.amber.withOpacity(0.12)
                              : const Color(0xFFEB4724).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCompleted
                              ? IconlyBold.ticket_star
                              : IconlyBold.activity,
                          color: isCompleted
                              ? Colors.amber.shade600
                              : const Color(0xFFEB4724),
                          size: 24,
                        ),
                      ),
                      title: Text(
                        isCompleted
                            ? "Milestone Achieved (100 Pts)"
                            : "Active Bonus Progress ($displaySum/100 Pts)",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff111827),
                        ),
                      ),
                      subtitle: Text(
                        isCompleted
                            ? "Tap to view earned bonuses in this cycle"
                            : "Earning towards your next discount",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      children: cycleItems.map((BonusHistory history) {
                        final isAdd = history.type == 'add';
                        final date = history.createdAt != null
                            ? DateTime.parse(history.createdAt!)
                            : DateTime.now();
                        final formattedDate = DateFormat(
                          'MMM dd, yyyy • hh:mm a',
                        ).format(date);

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: history == cycleItems.last
                                    ? Colors.transparent
                                    : Colors.grey.shade100,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isAdd
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isAdd
                                      ? IconlyLight.arrow_up_2
                                      : IconlyLight.arrow_down_2,
                                  color: isAdd ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      history.reason ??
                                          (isAdd
                                              ? "Bonus Earned"
                                              : "Bonus Redeemed"),
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff111827),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formattedDate,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${isAdd ? '+' : '-'}${history.amount?.abs()}",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isAdd ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          }

          // Wrap in a Column or Padding if needed, but since content is a ListView,
          // we can just return it, letting its padding handle spacing.
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: content,
          );
        },
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                ),
                Container(
                  height: 20,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
