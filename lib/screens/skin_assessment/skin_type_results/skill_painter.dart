import 'package:flutter/material.dart';

class SkinIllustrationPainter extends CustomPainter {
  final bool isDarkMode;

  SkinIllustrationPainter({this.isDarkMode = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw main large blob (dark green)
    paint.color = const Color(0xFF3A5A40);
    final path1 = Path();
    path1.moveTo(size.width * 0.3, size.height * 0.2);
    path1.quadraticBezierTo(
      size.width * 0.15, size.height * 0.35,
      size.width * 0.2, size.height * 0.55,
    );
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.75,
      size.width * 0.45, size.height * 0.8,
    );
    path1.quadraticBezierTo(
      size.width * 0.65, size.height * 0.85,
      size.width * 0.75, size.height * 0.7,
    );
    path1.quadraticBezierTo(
      size.width * 0.85, size.height * 0.55,
      size.width * 0.75, size.height * 0.35,
    );
    path1.quadraticBezierTo(
      size.width * 0.65, size.height * 0.15,
      size.width * 0.45, size.height * 0.15,
    );
    path1.quadraticBezierTo(
      size.width * 0.35, size.height * 0.15,
      size.width * 0.3, size.height * 0.2,
    );
    path1.close();
    canvas.drawPath(path1, paint);

    // Draw second blob (medium green) - overlapping
    paint.color = const Color(0xFF588157);
    final path2 = Path();
    path2.moveTo(size.width * 0.4, size.height * 0.35);
    path2.quadraticBezierTo(
      size.width * 0.25, size.height * 0.4,
      size.width * 0.2, size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.18, size.height * 0.75,
      size.width * 0.35, size.height * 0.85,
    );
    path2.quadraticBezierTo(
      size.width * 0.5, size.height * 0.92,
      size.width * 0.65, size.height * 0.88,
    );
    path2.quadraticBezierTo(
      size.width * 0.8, size.height * 0.82,
      size.width * 0.85, size.height * 0.65,
    );
    path2.quadraticBezierTo(
      size.width * 0.88, size.height * 0.5,
      size.width * 0.75, size.height * 0.4,
    );
    path2.quadraticBezierTo(
      size.width * 0.6, size.height * 0.32,
      size.width * 0.4, size.height * 0.35,
    );
    path2.close();
    canvas.drawPath(path2, paint);

    // Draw textured circle (white with green dots)
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.65),
      size.width * 0.18,
      paint,
    );

    // Draw dots pattern
    paint.color = const Color(0xFF588157);
    final random = [
      Offset(size.width * 0.65, size.height * 0.58),
      Offset(size.width * 0.72, size.height * 0.56),
      Offset(size.width * 0.78, size.height * 0.6),
      Offset(size.width * 0.68, size.height * 0.63),
      Offset(size.width * 0.75, size.height * 0.65),
      Offset(size.width * 0.82, size.height * 0.67),
      Offset(size.width * 0.66, size.height * 0.68),
      Offset(size.width * 0.73, size.height * 0.71),
      Offset(size.width * 0.79, size.height * 0.73),
      Offset(size.width * 0.62, size.height * 0.72),
      Offset(size.width * 0.85, size.height * 0.62),
      Offset(size.width * 0.7, size.height * 0.75),
    ];

    for (var offset in random) {
      final ellipse = Path();
      ellipse.addOval(Rect.fromCenter(
        center: offset,
        width: 6,
        height: 10,
      ));
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(0.3);
      canvas.translate(-offset.dx, -offset.dy);
      canvas.drawPath(ellipse, paint);
      canvas.restore();
    }

    // Add small accent dot
    paint.color = const Color(0xFFB4A89A);
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.25),
      4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}