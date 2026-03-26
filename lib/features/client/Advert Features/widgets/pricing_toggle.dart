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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton("Monthly", !isYearly),
          _buildToggleButton("Yearly", isYearly),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool active) {
    return GestureDetector(
      onTap: () => onChanged(text == "Yearly"),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xff651313) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: const Color(0xff651313).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey.shade600,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
