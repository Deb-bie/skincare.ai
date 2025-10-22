import 'package:flutter/material.dart';

class GenderOption extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderOption({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20
        ),
        decoration: BoxDecoration(
          // color: Colors.white,
          color: isSelected
              ? const Color(0x71B8B3E8)
              : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected
                ? const Color(0x71B8B3E8)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          children: [

            // Container(
            //   width: 24,
            //   height: 24,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     border: Border.all(
            //       color: isSelected
            //           ? const Color(0xFFB8B3E8)
            //           : const Color(0xFFE0E0E0),
            //       width: 2,
            //     ),
            //     color: Colors.white,
            //   ),
            // ),
            //
            // const SizedBox(width: 16),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),

            if (icon != null) ...[
              const SizedBox(width: 12),
              Icon(
                icon,
                size: 24,
                color: Colors.black87,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
