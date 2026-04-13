import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BonusProgressCard extends StatelessWidget {
  final int bonus;
  final String bonusStatus;
  final String registerSource;

  const BonusProgressCard({
    super.key,
    required this.bonus,
    required this.bonusStatus,
    required this.registerSource,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedBonus = bonus.clamp(0, 100);
    final progressValue = normalizedBonus / 100;
    final pointsLeft = 100 - normalizedBonus;
    final isAvailable = bonusStatus == "BonusAvailable";
    final sourceLabel = registerSource == "mobile" ? "Mobile" : "Website";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B1710), Color(0xFFB52E1D), Color(0xFFE24122)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B1710).withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, size: 15, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      "Bonus",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                "$normalizedBonus/100",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isAvailable
                ? "Discount unlocked! 50% bonus is ready."
                : "$pointsLeft points left to unlock 50% discount.",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.95),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              minHeight: 9,
              value: progressValue,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMetaChip("Source: $sourceLabel"),
              const SizedBox(width: 8),
              _buildMetaChip(isAvailable ? "Status: Ready" : "Status: In Progress"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
