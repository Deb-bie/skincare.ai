import 'package:flutter/material.dart';

Widget buildImageSection(String imageUrl) {
  return Container(
    width: double.infinity,
    height: 400,
    decoration: const BoxDecoration(
      color: Color(0xFFEDE8D8),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
    child: Center(
      child: Image.asset(
        imageUrl,
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade400,
            child: Icon(
                Icons.image,
                size: 60,
                color: Colors.grey.shade500),
          );
        },
      ),
    ),
  );
}