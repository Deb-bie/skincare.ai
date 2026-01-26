import 'package:flutter/material.dart';

Widget buildChip(String label, Color bgColor, Color textColor) {

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color: textColor,
        fontFamily: 'Poppins',
      ),
    ),
  );
}
