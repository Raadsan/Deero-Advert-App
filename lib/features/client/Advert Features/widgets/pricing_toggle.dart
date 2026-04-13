import 'package:flutter/material.dart';

class PricingToggle extends StatelessWidget {
  final bool isYearly;
  final ValueChanged<bool> onChanged;

  const PricingToggle({
    super.key,
    required this.isYearly,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          // The animated sliding background pill
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            left: isYearly ? 100 : 0,
            right: isYearly ? 0 : 100,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff651313),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff651313).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
            ),
          ),
          // The clickable text layers
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: !isYearly ? Colors.white : Colors.grey.shade600,
                        fontWeight: !isYearly ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                      child: const Text("Monthly"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: isYearly ? Colors.white : Colors.grey.shade600,
                        fontWeight: isYearly ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                      child: const Text("Yearly"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
