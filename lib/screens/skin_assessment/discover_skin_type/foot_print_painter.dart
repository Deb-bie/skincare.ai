import 'package:flutter/material.dart';

class FootprintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B7355)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.quadraticBezierTo(
      size.width * 0.7, size.height * 0.1,
      size.width * 0.75, size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.5,
      size.width * 0.7, size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.6, size.height * 0.85,
      size.width * 0.4, size.height * 0.95,
    );
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.9,
      size.width * 0.15, size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.1, size.height * 0.5,
      size.width * 0.2, size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.1,
      size.width * 0.5, 0,
    );
    path.close();

    canvas.drawPath(path, paint);

    final toePaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final toeX = size.width * (0.25 + i * 0.12);
      final toeY = size.height * 0.05 + (i % 2 == 0 ? 0 : 5);
      canvas.drawCircle(Offset(toeX, toeY), 6, toePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}