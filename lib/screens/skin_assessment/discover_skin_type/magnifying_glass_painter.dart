import 'package:flutter/material.dart';

class MagnifyingGlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Outer circle
    paint.color = const Color(0xFF81C784);
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.35),
      size.width * 0.35,
      paint,
    );

    // Inner circle
    paint.color = const Color(0xFF66BB6A);
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.35),
      size.width * 0.25,
      paint,
    );

    // Leaf inside
    final leafPaint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final leafPath = Path();
    final centerX = size.width * 0.4;
    final centerY = size.height * 0.35;

    // Simple leaf shape
    leafPath.moveTo(centerX - 20, centerY);
    leafPath.quadraticBezierTo(
      centerX - 15, centerY - 25,
      centerX, centerY - 30,
    );
    leafPath.quadraticBezierTo(
      centerX + 15, centerY - 25,
      centerX + 20, centerY,
    );
    leafPath.quadraticBezierTo(
      centerX + 15, centerY + 25,
      centerX, centerY + 30,
    );
    leafPath.quadraticBezierTo(
      centerX - 15, centerY + 25,
      centerX - 20, centerY,
    );

    canvas.drawPath(leafPath, leafPaint);

    // Leaf vein
    leafPaint.strokeWidth = 1.5;
    canvas.drawLine(
      Offset(centerX, centerY - 30),
      Offset(centerX, centerY + 30),
      leafPaint,
    );

    // Handle
    paint.color = const Color(0xFF66BB6A);
    paint.strokeWidth = 4;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.58),
      Offset(size.width * 0.85, size.height * 0.85),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
