import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BonusProgressCard extends StatefulWidget {
  final int bonus;
  final String bonusStatus;
  final String registerSource;

  final int minBonus;
  final int discount;

  const BonusProgressCard({
    super.key,
    required this.bonus,
    required this.bonusStatus,
    required this.registerSource,
    this.minBonus = 100,
    this.discount = 50,
  });

  @override
  State<BonusProgressCard> createState() => _BonusProgressCardState();
}

class _BonusProgressCardState extends State<BonusProgressCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final normalizedBonus = widget.bonus.clamp(0, widget.minBonus);
    final progressValue = normalizedBonus / widget.minBonus;
    final pointsLeft = widget.minBonus - normalizedBonus;
    final pointWord = pointsLeft == 1 ? "point" : "points";
    final isAvailable = widget.bonusStatus == "BonusAvailable";
    final milestones = [0, (widget.minBonus * 0.15).toInt(), (widget.minBonus * 0.3).toInt(), (widget.minBonus * 0.6).toInt(), widget.minBonus];
    const cardBg = Color(0xFFFCD7C3);
    const borderColor = Color(0xFFE24122);
    const primaryText = Color(0xFF2D2D2D);
    const mutedText = Color(0xFF5D6574);
    const accent = Color(0xFFEF7044);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withOpacity(0.25), width: 1.2),
        boxShadow: [
          // BoxShadow(
          //   color: borderColor.withOpacity(0.08),
          //   blurRadius: 10,
          //   offset: const Offset(0, 4),
          // ),
        ],
      ),
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
                  color: Colors.white.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, size: 15, color: accent),
                    const SizedBox(width: 4),
                    Text(
                      "Bonus",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                "$normalizedBonus/${widget.minBonus}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: primaryText,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: primaryText,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const horizontalPadding = 16.0;
                final trackWidth = constraints.maxWidth - (horizontalPadding * 2);
                final knobSize = 17.0;
                final progressWidth = trackWidth * progressValue;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 6,
                        child: Container(
                          height: 5,
                          width: trackWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7E7E7).withOpacity(0.65),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        child: Container(
                          height: 5,
                          width: progressWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xff651313),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      ...milestones.map((milestone) {
                        final left =
                            (trackWidth * (milestone / widget.minBonus)) - (knobSize / 2);
                        final reached = normalizedBonus >= milestone;
                        return Positioned(
                          top: 0,
                          left: left,
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 240),
                                height: knobSize,
                                width: knobSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: reached
                                        ? const Color(0xff651313)
                                        : const Color(0xFFCFCFCF),
                                    width: 2.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 32,
                                child: Text(
                                  milestone.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: mutedText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 260),
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAvailable
                        ? "Discount unlocked! ${widget.discount}% bonus is ready."
                        : "Only $pointsLeft $pointWord left to unlock ${widget.discount}% discount.",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor.withOpacity(0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rewards you can get with Stars",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _rewardRow(
                          points: "${milestones[1]}",
                          text: "Signup step completed",
                          enabled: normalizedBonus >= milestones[1],
                        ),
                        _rewardRow(
                          points: "${milestones[2]}",
                          text: "Step 2 completed",
                          enabled: normalizedBonus >= milestones[2],
                        ),
                        _rewardRow(
                          points: "${milestones[3]}",
                          text: "Step 3 completed",
                          enabled: normalizedBonus >= milestones[3],
                        ),
                        _rewardRow(
                          points: "${widget.minBonus}",
                          text: "Unlock ${widget.discount}% bonus discount",
                          enabled: normalizedBonus >= widget.minBonus,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }

  Widget _rewardRow({
    required String points,
    required String text,
    required bool enabled,
    bool isLast = false,
  }) {
    final rowColor = enabled
        ? const Color(0xFF252525)
        : const Color(0xFF5A5A5A);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              points,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: rowColor,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: rowColor,
                fontWeight: enabled ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
